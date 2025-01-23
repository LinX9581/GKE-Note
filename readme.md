# STEP
1. Create Cluster & Connect to GKE Cluster  
2. Create Docker Image & push to GCR  

## Create Cluster & Connect to GKE Cluster

* Get Service Account Auth
gcloud auth activate-service-account --key-file jsonPath
gcloud config set project projectName

* Install gcloud & kubectl  
```
https://cloud.google.com/sdk/docs/install-sdk#linux

curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
gcloud components install kubectl
```

* gcloud create cluster  
gcloud container clusters create linxgke --spot  

* Manual Create GKE Cluster & use gcloud connect to cluster  
gcloud container clusters get-credentials linxgke --zone=asia-east1-a --project=projectName

## Create Docker Image & push to artifact registry
```
GCP_PROJECT_NAME=analytics
AR_PROJECT_NAME=nodejs-repo
PROJECT_NAME=nodejs-template
APP_VERSION=1.8
CLOUDRUN_SERVICE=my-service1

gcloud auth activate-service-account --key-file $PROJECT_NAME.json
gcloud config set project $GCP_PROJECT_NAME
gcloud auth configure-docker $AR_TARGET
gcloud auth configure-docker --quiet
gcloud artifacts repositories create $AR_PROJECT_NAME --repository-format=docker --location=asia --description="Docker repository"
docker build -t asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION .
docker images
docker push asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION
```

## push to cloud run
```
gcloud run deploy $CLOUDRUN_SERVICE \
    --image=asia-docker.pkg.dev/$GCP_PROJECT_NAME/$AR_PROJECT_NAME/$PROJECT_NAME:$APP_VERSION \
    --region=asia-east1 \
    --platform=managed \
    --allow-unauthenticated \
    --memory=512Mi \
    --cpu=1 \
    --max-instances=3 \
    --timeout=10m \
    --concurrency=1 \
    --set-env-vars=db_user=dev,db_password=00000000
```

## Deploy by using ArgoCD
1. argoCD-deploy  
[nodejs-helm-template](https://github.com/LinX9581/nodejs-helm-template)

2. single-component-deploy  
cd single-component-deploy  


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