
curl -L https://istio.io/downloadIstio | sh -
cd istio-1.24.0
export PATH=$PWD/bin:$PATH
kubectl create namespace istio-system
istioctl install --set profile=ambient --skip-confirmation


## 刪除
istioctl uninstall --purge
kubectl delete namespace istio-system

## 故障排除
kubectl get events -n istio-system
kubectl describe pods -n istio-system

可能是資源不夠 可以試著增加 node pool 的節點數
kubectl top nodes
