# Lab 1

k get nodes --no-headers | wc -l
k get nodes -o wide
k cluster-info
k run nginx-pod --image=nginx
k get po nginx-pod

# Lab 2

k get po --no-headers | wc -l
k run nginx --image nginx
k get po -o wide
k get po webapp -o yaml