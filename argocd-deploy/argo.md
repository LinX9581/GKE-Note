## ArgoCD
https://github.com/LinX9581/nodejs-helm-template

## Template 
https://github.com/LinX9581/nodejs-helm-template

sudo kubectl get ingressclasses
確定 Class 後
helm 的 ingress 區塊就能指定該 Class
ingress:
  enabled: true
  className: nginx