## https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
## https://kubernetes.io/docs/tasks/tls/certificate-issue-client-csr/
## https://kubernetes.io/docs/concepts/workloads/pods/init-containers/

### remove if needed
vi $HOME/.kube/config
cat /root/martin.crt | base64 | tr -d "\n"
cat /root/martin.key | base64 | tr -d "\n"

### remove 
k config delete-user martin
k config delete-context developer
rm -rf *

### Generate a private key and CSR
openssl genrsa -out martin.key 2048
openssl req -new -key martin.key -subj "/CN=martin" -out martin.csr

### Method 1 Sign the CSR with the cluster CA
openssl x509 -req -in martin.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -out martin.crt -CAcreateserial

### validate certificate
openssl x509 -in martin.crt -text -noout | grep -i subject

### Method 2 to CSR signed
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: martin          
spec:
  request: <martin.csr base64>
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF

k get csr
k certificate approve martin

### add creds and context. Set default context
k config set-credentials martin --client-certificate=/root/martin.crt --client-key=/root/martin.key --embed-certs=false
k config set-context developer --cluster=kubernetes --user=martin
k config view

### role and rolebindings
k create role developer-role --verb=* --resource=svc,pvc,po -n development
k -n development get roles developer-role -o yaml
k create rolebinding developer-rolebinding --role="developer-role" -n development --user="martin"
k -n development get rolebindings developer-rolebinding -o yaml
k auth can-i get svc --user=martin -n development
k auth can-i get po --user=martin -n development
k auth can-i get pvc --user=martin -n development


# create svc with user martin
k config use-context developer
k create svc nodeport jekyll-node-service -n development --tcp=4000:4000 -o yaml --dry-run=client > svc.yaml

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  namespace: development
  labels:
    app: jekyll-node-service
  name: jekyll-node-service
spec:
  ports:
  - name: 4000-4000
    port: 4000
    protocol: TCP
    targetPort: 4000
    nodePort: 30097
  selector:
    app: jekyll-node-service
  type: NodePort
status:
  loadBalancer: {}

k -n development get svc jekyll-node-service -o yaml

# check storageClass
k config use-context kubernetes-admin@kubernetes
k get sc local-storage -o yaml
k config use-context developer

# create pvc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  namespace: development
  name: jekyll-site
spec:
  accessModes:
    - ReadWriteMany
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-storage

# create pod
apiVersion: v1
kind: Pod
metadata:
  name: jekyll
  namespace: development
  labels:
    run: jekyll
spec:
  containers:
  - name: jekyll
    image: gcr.io/kodekloud/customimage/jekyll-serve
    command: ['sh', '-c', 'cd /site && bundle install && bundle exec jekyll serve --host 0.0.0.0 --port 4000']
    volumeMounts:
      - name: site
        mountPath: /site
  initContainers:
  - name: copy-jekyll-site
    image: gcr.io/kodekloud/customimage/jekyll
    command: ['sh', '-c', 'rm -rf /site/* && jekyll new /site && cd /site && bundle install']
    volumeMounts:
      - name: site
        mountPath: /site
  volumes:
    - name: site
      persistentVolumeClaim:
        claimName: jekyll-site

# pvc bounded to pv
k -n development get po,pvc