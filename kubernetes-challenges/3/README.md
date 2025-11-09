# create ns
k create ns vote

# create vote deployment and expose it
k create deployment vote --image=dockersamples/examplevotingapp_vote -n vote
k -n vote get deployments.apps 
k -n vote expose deployment/vote --name vote --type=NodePort --port=8080 -o yaml --dry-run=client > svc.yaml

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: vote
  name: vote
  namespace: vote
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 80
    nodePort: 31000
  selector:
    app: vote
  type: NodePort
status:
  loadBalancer: {}

k -n vote describe svc/vote | grep -i endpoints

# create redis deployment and expose it
k create deployment redis --image=redis:alpine -o yaml --dry-run=client > redis.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: redis
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  strategy: {}
  template:
    metadata:
      namespace: vote
      labels:
        app: redis
    spec:
      containers:
      - image: redis:alpine
        name: redis
        resources: {}
        volumeMounts:
        - mountPath: /data
          name: redis-data
      volumes:
        - name: redis-data
          emptyDir: {}

k -n vote expose deployment/redis --port=6379 --name=redis
k -n vote describe svc/redis | grep -i endpoints

# create deploymnet worker
k -n vote create deployment worker --image=dockersamples/examplevotingapp_worker
k -n vote get deploy

# create db deploy and expose it
k -n vote create deployment db --image=postgres:15-alpine -o yaml --dry-run=client > db.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: db
  name: db
  namespace: vote
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: db
    spec:
      containers:
      - image: postgres:15-alpine
        name: postgres
        resources: {}
        volumeMounts:
        - mountPath: /var/lib/postgresql/data
          name: db-data
      volumes:
        - name: db-data
          emptyDir: {}

k -n vote set env -f db.yaml POSTGRES_HOST_AUTH_METHOD=trust
k -n vote describe deployments.apps/db
k -n vote expose deployment/db --port=5432 --name db
k -n vote describe svc/db | grep -i endpoints

# create and expose result deployment
k -n vote create deployment result --image=dockersamples/examplevotingapp_result
k -n vote expose deployment/result --name=result --port=8081 --type=NodePort -o yaml --dry-run=client > svc.yaml

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: result
  name: result
  namespace: vote
spec:
  ports:
  - port: 8081
    protocol: TCP
    targetPort: 80
    nodePort: 31001
  selector:
    app: result
  type: NodePort
status:
  loadBalancer: {}

k -n vote describe svc/result | grep -i endpoints