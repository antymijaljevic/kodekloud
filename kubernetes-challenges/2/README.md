# fix kube-api
k config view | grep -i server
sudo journalctl -u kubelet -r | grep -i 'kube-apiserver' | head
sudo crictl ps
sudo crictl ps -a | grep -i 'apiserver'
crictl logs f9b682b758b80

# fix coredns
k -n kube-system edit deployments.apps/coredns
registry.k8s.io/coredns/coredns:v1.8.6

# node01 to be ready
k uncordon node01

# create svc
k create service nodeport gop-fs-service --tcp=8080:8080

apiVersion: v1
kind: Service
metadata:
  labels:
    app: gop-fs-service
  name: gop-fs-service
spec:
  ports:
  - name: 8080-8080
    port: 8080
    protocol: TCP
    targetPort: 8080
    nodePort: 31200

# create pv
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
  - ReadWriteMany
    #storageClassName: local-storage
  hostPath:
    path: /web

# create pvc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteMany
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
  volumeName: data-pv

# create pod with pvc
k run gop-file-server --image=kodekloud/fileserver -o yaml --dry-run=client > pod.yaml

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: gop-file-server
  name: gop-file-server
spec:
  containers:
  - image: kodekloud/fileserver
    name: gop-file-server
    volumeMounts:
      - name: data-store
        mountPath: /web
    resources: {}
  volumes:
  - name: data-store
    persistentVolumeClaim:
      claimName: data-pvc
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

# copy files to node01
scp /media/* node01:/web