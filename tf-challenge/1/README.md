apt list -a terraform

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform=1.1.5 && alias tf='terraform' && tf version



cat ~/.kube/config
alias tf='terraform'
k config get-contexts
kubectl get pods --all-namespaces --show-labels --kubeconfig ~/.kube/config
tf init && tf fmt && tf validate
k get deploy,po,svc