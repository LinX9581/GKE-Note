# 啟用deployment
kubectl apply -f /k8s/dev.yaml

# 以該deployment 建立service
kubectl expose deploy deployment1 --type=NodePort --name=my-deployment-service

# 更新原來的deployment
他會新增新的Pod來取代舊的 
[yaml 上的container name] = [dockerhub上的image name]
my-pod=zxcvbnius/docker-demo:v2.0.0
kubectl set image deploy/deployment1 my-pod=zxcvbnius/docker-demo:v2.0.0

# 可以看到版本紀錄
kubectl rollout history deploy deployment1

# 到前一版
kubectl rollout undo deployment deployment1

# 到第三版
kubectl rollout undo deploy deployment1 --to-revision=3

# 停止
kubectl rollout pause deployment/deployment1
kubectl rollout resume deployment/deployment1

# 更改效能配置
kubectl set resources deployment deployment1 --limits=cpu=200m,memory=512Mi

參考
https://blog.kennycoder.io/2021/01/09/Kubernetes%E6%95%99%E5%AD%B8%E7%B3%BB%E5%88%97-%E6%BB%BE%E5%8B%95%E6%9B%B4%E6%96%B0%E5%B0%B1%E7%94%A8Deployment/