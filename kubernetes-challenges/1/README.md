## https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
# https://kubernetes.io/docs/tasks/tls/certificate-issue-client-csr/
### manual
vi $HOME/.kube/config
cat /root/martin.crt | base64 | tr -d "\n"
cat /root/martin.key | base64 | tr -d "\n"

### remove 
k config delete-user martin
k config delete-context developer@kubernetes
rm -rf *

# Generate a private key and CSR
openssl genrsa -out martin.key 2048
openssl req -new -key martin.key -subj "/CN=martin" -out martin.csr

# Sign the CSR with the cluster CA
openssl x509 -req -in martin.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -out martin.crt -CAcreateserial

# validate certificate
openssl x509 -in martin.crt -text -noout | grep -i subject

k config set-credentials martin --client-certificate=/root/martin.crt --client-key=/root/martin.key --embed-certs=true
k config view


k config set-credentials martin --client-certificate=martin.crt --client-key=martin.key
k config set-context developer --cluster=kubernetes --user=martin
k config use-context developer
k config use-context kubernetes-admin@kubernetes