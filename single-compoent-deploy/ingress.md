# 建立 ingress-nginx
kubectl create namespace ingress-nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml -n ingress-nginx
kubectl get all -n ingress-nginx

# 建立 namespace,deploy,service,ingress,nginx-controller
cd single-compoent-deploy

* 依序建立 create namespace -> env -> deployment -> service -> ingress
kubectl create namespace nodejs-template1
kubectl create configmap nodejs-template-env --from-env-file=/var/www/.env -n nodejs-template1
kcy deploy.yaml -n nodejs-template1
kcy service.yaml -n nodejs-template1
kcy ingress.yaml -n nodejs-template1

* 檢視所有 nodejs-template1
kubectl get all -n nodejs-template1
kgp -n nodejs-template1

* 連線方式
pod 內部IP:Port
worker node IP:Service Port
ingress 設定的 domain 

* 狀況排查 (由底層排查到外層)
1. k logs podname -n nodejs-template1
2. service port = deployment port = pod port
3. service type: ClusterIP = domain , type: NodePort


※ CLI版本 要對應k8s版本 
※ 建出來的任何服務 只有在namespace=nodejs-template1才會作用
※ 連網的IP是pod本身的內部IP
※ 刪除服務 kcy -> kdy

# configMap
* 編輯 configMap
kubectl edit configmap nodejs-template-env -n nodejs-template1
* 讓pod重吃configMap
kubectl rollout restart web -n nodejs-template1
* 讓 deployment 重吃 configMap (強制重啟pod)
kubectl rollout restart deployment/deployment1
* 不會強制重啟pod
kubectl rollout pause deployment/deployment1
kubectl apply -f deployment.yaml
kubectl rollout resume deployment/deployment1

# 版本紀錄
kubectl rollout history deploy deployment1 -n nodejs-template1
* 更改deploy指定image
kubectl set image deploy/deployment1 my-pod=asia.gcr.io/test-analytics/nodejs-template:3.2 -n nodejs-template1
* 直接改deploy.yaml
k apply -f deploy.yaml -n nodejs-template1
* 退版
kubectl rollout undo deployment deployment1 -n nodejs-template1

# 參考
* 完整步驟參考 deploy,service,ingress
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%B8%80-92944d4bf97d
https://medium.com/andy-blog/kubernetes-%E9%82%A3%E4%BA%9B%E4%BA%8B-ingress-%E7%AF%87-%E4%BA%8C-559c7a41404b

* deploy設定
https://blog.kennycoder.io/2021/01/09/Kubernetes%E6%95%99%E5%AD%B8%E7%B3%BB%E5%88%97-%E6%BB%BE%E5%8B%95%E6%9B%B4%E6%96%B0%E5%B0%B1%E7%94%A8Deployment/

* 官方
https://github.com/kubernetes/ingress-nginx
https://kubernetes.io/docs/concepts/services-networking/ingress/
https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/
