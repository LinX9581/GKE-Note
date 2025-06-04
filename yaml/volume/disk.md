
## 預設會有 3個 storage class
kubectl get storageclass
1. premium-rwo (SSD 且一次只能被一個 Pod 使用)
2. standard
3. standard-rwo(default)

預設的 storageClass 只要把 pod 刪除，Disk 會一併被刪除
有特定保存需求通常會另外建立 Storage Class

* 建立 Storage Class
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: premium-rwo-retain
provisioner: pd.csi.storage.gke.io
parameters:
  type: pd-ssd
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true

下面 = 創建一個 GCP 10G Disk 用新建立的 strageclass premium-rwo-retain
grafana:
  enabled: true
  persistence:
    enabled: true
    size: 10Gi
    storageClassName: premium-rwo-retain
    #existingClaim: storage-loki-0 # 指定已存在 pvc 名稱
    accessModes:
      - ReadWriteOnce

用 helm 安裝後會自動建立 pv 而且建立 GCP Disk
如果已有建立 pvc 也可以指定 pvc 名稱
假設要讓 pvc 去綁定已存在的 pv 就指定 pv 的 volumeName
  volumeName: pvc-cb2fc5f9-be24-4656-9ffd-56cb949c4609

並且把原先pv 可能有綁定的 pvc 清除 重新建立 pvc 就能重新綁定
sudo kubectl patch pv pvc-cb2fc5f9-be24-4656-9ffd-56cb949c4609 -p '{"spec":{"claimRef": null}}'
