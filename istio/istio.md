
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.24.0
export PATH=$PWD/bin:$PATH

* 設環境變數才能用 istio 指令
export PATH=$PWD/bin:$PATH

istioctl profile list
```
default profile 會根據 IstioOperatorAPI 的預設值進行安裝
demo profile 顧名思義就是拿來做 demo 用的
minial profile 只安裝了 Istio traffic management 需要使用的組件，也就是 istiod
remote profile 拿來安裝在 multi-cluster 中設定 remote cluster 的 Istio
```

* 安裝 demo
istioctl install --set profile=demo
kubectl get pod -n istio-system

* 預設建立的 service 會有個外部 GCP LB 的外部 IP
kubectl get svc istio-ingressgateway -n istio-system

* 讓預設 ns 加入 istio
kubectl label namespace nn-helm-template istio.io/dataplane-mode=ambient
kubectl label namespace nn-helm-template istio-injection=enabled

* 建立範例 podc
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl get po -n default // 會看到 ready 有兩個, 一個 = pod 一個 = istio sidecar
kubectl get all

* 建立 gateway(L4~L6) virtualservice(L7 為了要對外)
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml

* 取得IP
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo $GATEWAY_URL
192.168.8.128:32765


## 其他服務

* install other services
kubectl apply -f samples/addons

* export kiali
預設 istio 就會建立 kiali 的 service
kubectl port-forward --address 0.0.0.0 svc/kiali 3008:20001 -n istio-system &

* export grafana
kubectl port-forward --address 0.0.0.0 svc/grafana 3006:3000 -n istio-system &

* export argocd
kubectl port-forward svc/argocd-server --address 0.0.0.0 -n argocd 3007:443 &


## uninstall
istioctl uninstall -y --purge
kubectl delete all --all -n istio-system

* 參考

https://hackmd.io/@imo-ininder/BylKO-pEw

