# 原理

實際上會建立 GCP Loadbalancer
連規則都會一併建立完成
如果刪除 ingress 則 GCP Loadbalancer 跟著刪除


## 有無狀態的差異
有状态与无状态:

Deployment：是为无状态应用设计的，这意味着每个Pod都是可互换的，不需要保持任何特定的状态。
StatefulSet：为有状态应用设计，例如数据库。它确保Pods拥有持久标识和稳定的网络主机名。
Pod标识:

Deployment：Pods没有稳定、可预测的名称。
StatefulSet：Pods有一个基于索引的持久和有序的名称，如web-0、web-1等。
部署和扩展顺序:

Deployment：Pods可以同时创建和终止。
StatefulSet：Pods按照顺序一次创建一个，并且在下一个Pod启动之前，前一个必须已经在运行和就绪。
存储:

Deployment：通常与无状态的存储一起使用，如emptyDir。
StatefulSet：通常与PersistentVolume一起使用，确保每个Pod都有自己的持久存储。它还允许每个Pod的存储与其它Pod的存储分开。
用例:

Deployment：无状态应用，如Web服务器、前端、API网关等。
StatefulSet：有状态应用，如数据库（例如PostgreSQL、MongoDB）、分布式存储系统（例如Zookeeper、Cassandra）等。