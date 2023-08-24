
# deployment 設定 vpc

* deployment.yaml

```
container裡面
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
volumeMounts:
  - name: nodejs-template3-volume
    mountPath: /tmp

和conatiner同層

volumes:
  - name: nodejs-template3-volume
    persistentVolumeClaim:
      claimName: {{ .Values.persistence.existingClaim }}
```

values.yaml
persistence:
  enabled: true
  existingClaim: pod-pvc

* pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pod-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi


* 取得所有
kubectl get pvc --all-namespaces

* 查看pvc詳細
kubectl describe pvc -n monitor storage-prometheus-alertmanager-0

可以查看下面這行判斷有沒有被使用
Used By:       <none>






* 建立 disk
gcloud compute disks create pod-pd --size=10G --type=pd-balanced --zone=asia-east1-a