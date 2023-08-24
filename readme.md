# STEP
1. Create Cluster & Connect to GKE Cluster  
2. Create Docker Image & push to GCR  

## Deploy method
1. argoCD-deploy  
2. single-comnent-deploy  


## Create Cluster & Connect to GKE Cluster

* Get Service Account Auth
gcloud auth activate-service-account --key-file jsonPath
gcloud config set project terra-test-353202

* Install gcloud & kubectl  
```
https://cloud.google.com/sdk/docs/install-sdk#linux

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-419.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-419.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
source ~/.bashrc
gcloud components install kubectl
```

* gcloud create cluster  
gcloud container clusters create linxgke --spot  

* Manual Create GKE Cluster & use gcloud connect to cluster  
gcloud container clusters get-credentials linx-gke --zone=asia-east1 --project=k8s-2022-09-05  

## Create Docker Image & push to GCR
Auth
```
gcloud auth activate-service-account --key-file jsonPath
sudo usermod -a -G docker ${USER}
gcloud auth configure-docker
gcloud config set project test-project
```

image push to gcr
```
docker build -t nodejs-template:3.9 . --no-cache
docker tag nodejs-template:3.9 asia.gcr.io/test-project/nodejs-template:3.9
※ 執行container  (但環境變數吃進去後修改 要砍掉container 再重建) 下一行是用掛載的方式
docker run --name nodejs-template -p 3006:3005 --env-file /var/www/.env -itd asia.gcr.io/test-project/nodejs-template:3.9
docker run --name nodejs-template -p 3006:3005 -itd -v /var/www/.env:/usr/src/app/.env asia.gcr.io/test-project/nodejs-template:3.9
docker push asia.gcr.io/test-project/nodejs-template:3.9
```


## 問題排除

1. 如果遇到版本更新 而無法連接GKE  
```
從文件找最新版本 然後重裝  
https://cloud.google.com/sdk/docs/install-sdk#linux  

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-419.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-419.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
source ~/.bashrc
gcloud components install kubectl
```

2. mount問題
```
deployment 如果設置的是 pvc
代表這個pvc只在一個node生效 如果pod跨到另一個node 就會找不到pvc

要把
volumes:
- name: nodejs-template3-volume
    persistentVolumeClaim:
    claimName: {{ .Values.persistence.existingClaim }}

改成
- name: nodejs-template3-volume
  emptyDir: {}
長期保存->短期保存

或者在pvc設置
  accessModes:
    - ReadWriteOnce
改成
  accessModes:
    - ReadWriteMany
```