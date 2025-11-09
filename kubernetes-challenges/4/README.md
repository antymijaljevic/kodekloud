# https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

# create pv 1-6
ssh node01
mkdir /redis01

apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis01
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis01

# inspect cm
k get cm redis-cluster-configmap -o yaml

# create sts and expose it
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-cluster
  labels:
    app: redis-cluster
spec:
  selector:
    matchLabels:
      app: redis-cluster
  serviceName: "redis-cluster-service"
  replicas: 6
  template:
    metadata:
      labels:
        app: redis-cluster
    spec:
      containers:
      - name: redis
        image: redis:5.0.1-alpine
        command: ["/conf/update-node.sh", "redis-server", "/conf/redis.conf"]
        env:
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
                apiVersion: v1
        ports:
        - containerPort: 6379
          name: client
        - containerPort: 16379
          name: gossip
        volumeMounts:
        - name: conf
          mountPath: "/conf"
          readOnly: false
        - name: data
          mountPath: "/data"
          readOnly: false
      volumes:
        - name: conf
          configMap:
            name: redis-cluster-configmap
            defaultMode: 0755
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi


apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-service
spec:
  clusterIP: None
  selector:
    app: redis-cluster
  ports:
  - name: client
    port: 6379
    targetPort: 6379
  - name: gossip
    port: 16379
    targetPort: 16379

# execute command
kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 {end}')