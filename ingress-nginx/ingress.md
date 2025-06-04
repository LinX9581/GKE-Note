kubectl get ingressclass


argocd app create ingress-nginx \
--repo https://github.com/LinX9581/nginx-ingress \
--path . \
--dest-server https://kubernetes.default.svc \
--dest-namespace ingress-nginx \
--sync-policy automated

# 各別的domain ingress header 參考
https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/



helm 的 ingress 如果錯誤可以從
sudo kubectl logs -n ingress-nginx ingress-nginx-controller-6dd6d546bf-lpg9r | grep -i configuration-snippet | tail -10


/任何路徑都能訪問到背後 nodejs 的 router

而以下路徑有其他規則
/test 重定向到 /
/wp-content 重定向到 404
/wp-admin 重定向到 404

且 home.linx.blog 重定向到 nodejs.linx.blog

問題1
ingress 改爛 直接讓 ingress-nginx 掛掉