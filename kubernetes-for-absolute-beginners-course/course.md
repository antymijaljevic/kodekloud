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

# Lab 3
vi /home/bob/playbooks/practice.yaml

name: apple
color: red
weight: 90g

vi /home/bob/playbooks/practice.yaml

- apple
- apple
- apple
- apple

vi /home/bob/playbooks/practice.yaml

employee:
  name: john
  gender: male
  age: 24

vi /home/bob/playbooks/practice.yaml

- name: apple
  color: red
  weight: 100g
- name: orange
  color: orange
  weight: 90g
- name: mango
  color: yellow
  weight: 150g

# Lab 4
vi /home/bob/playbooks/practice.yaml

employees:
  - name: john
    gender: male
    age: 24

employees:
  - name: john
    gender: male
    age: 24
  - name: sarah
    gender: female
    age: 28

employee:
  name: john
  gender: male
  age: 24
  address:
    city: 'edison'
    state: 'new jersey'
    country: 'united states'
  payslips:
    - month: june
      amount: 1400
    - month: july
      amount: 2400
    - month: august
      amount: 3400

# Lab 5
k run web-pod --image=nginx -l app=web,env=prod -o yaml --dry-run=client > /root/web-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  labels:
    app: web
    env: prod
  name: web-pod
spec:
  containers:
  - image: nginx
    name: nginx-container

k create -f /root/web-pod.yaml

k run redis-pod --image=redis -l app=cache,env=dev -o yaml --dry-run=client > /root/redis-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  labels:
    app: cache
    env: dev
  name: redis-pod
spec:
  containers:
  - image: redis
    name: redis-container

 k create -f /root/redis-pod.yaml

 k get po --no-headers | wc -l

 vi /root/broken-pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: static-web
  labels:
    app: static
    env: prod
spec:
  containers:
    - name: httpd-container
      image: httpd

k create -f /root/broken-pod.yaml

k describe pod node-api | grep  -i APP_COLOR