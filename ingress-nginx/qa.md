原先有個網址 nodejs.linx.blog
他是用一般VM 裝 Nginx 裡面有一堆規則
現在要轉成 k8s ingress-nginx 1.12.2版 
而且因為資安問題 不能用
ServerSnippet
ConfigurationSnippet

原先 nginx 有以下規則
/test 重定向到 /
/wp-content 重定向到 404
/wp-admin 重定向到 404
home.linx.blog 重定向到 nodejs.linx.blog

location ~* ^/news/ {
    if ($uri ~* '[^a-zA-Z0-9\.\-\_\?\=\&\/]') {
        return 404;
    }
    if ($args ~* '[^a-zA-Z0-9\.\-\_\?\=\&\/]') {
        proxy_pass http://servlet/NOWnews/content.jsp?newsUrl=$uri;
    }
    proxy_set_header        Host $host;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
    #proxy_pass http://servlet/NOWnews/content.jsp?newsUrl=$request_uri;
    proxy_pass http://servlet/NOWnews/content.jsp?newsUrl=$uri&$args;
}

location ~ ^/cat/([^/]+)/page/(\d+)/$ {
    set $category $1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://servlet/NOWnews/newsListPager.jsp?newsUrl=/cat/$category/page/$2/;
}

location ~ ^/cat/([^/]+)/([^/]+)/page/(\d+)/$ {
    set $category $1;
    set $sub_category $2;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://servlet/NOWnews/newsListPager.jsp?newsUrl=/cat/$category/$sub_category/page/$3/;
}

upstream servlet {
  server 127.0.0.1:80;
}


我目前是用 helm create 以下是我的 values.yaml
# Default values for nodejs-helm-template.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 2

image:
  repository: asia-docker.pkg.dev/nownews-terraform/nodejs-repo/nodejs-template
  pullPolicy: IfNotPresent
  tag: "2.7.0"

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # Annotations to add to the service account
  annotations: {}
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name: ""

podAnnotations: {}

podSecurityContext: {}
  # fsGroup: 2000

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000

service:
  type: ClusterIP
  port: 3011

# 新增以下配置
application:
  port: 3011

ingress:
  enabled: true
  className: nginx
  annotations:
resources: {}
  # We usually recommend not to specify default resources and to leave this as a conscious
  # choice for the user. This also increases chances charts run on environments with little
  # resources, such as Minikube. If you do want to specify resources, uncomment the following
  # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
  # limits:
  #   cpu: 100m
  #   memory: 128Mi
  # requests:
  #   cpu: 100m
  #   memory: 128Mi

autoscaling:
  enabled: false
  minReplicas: 2
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
  # targetMemoryUtilizationPercentage: 80

nodeSelector: {}

tolerations: []

affinity: {}


我佈署方式都是用 ArgoCD 結合 github
請幫我建立 ingress-nginx 1.12.2版 
https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.2/deploy/static/provider/cloud/deploy.yaml

而且滿足最低程度的資安 同時又精簡 符合最佳實踐
別弄得太複雜