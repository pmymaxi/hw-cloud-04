# HW Cloud 04 — Yandex Cloud: MySQL и Kubernetes


## 1. MySQL

Создан кластер Managed Service for MySQL с параметрами:

- Name: `mysql-netology`
- Environment: `PRESTABLE`
- Version: `8.0`
- Disk: 20 GB
- Disk type: `network-ssd`
- Resource preset: `b2.medium`
- Deletion protection: enabled
- Backup start: `23:59`

Кластер размещён в трёх зонах:

```text
ru-central1-a
ru-central1-b
ru-central1-d
```

Для зон используются отдельные подсети:

```text
ru-central1-a → 192.168.20.0/24
ru-central1-b → 192.168.30.0/24
ru-central1-d → 192.168.40.0/24
```

Создана база данных:

```text
netology_db
```

Создан пользователь:

```text
netology
```

Пароль задаётся через Terraform variables.

## 2. Kubernetes

Создан Managed Kubernetes кластер:

```text
k8s-netology
```

Используется региональный Master:

```text
ru-central1
```

Master размещён в трёх зонах:

```text
ru-central1-a
ru-central1-b
ru-central1-d
```

### Kubernetes VPC

Используются подсети:

```text
ru-central1-a → 192.168.10.0/24
ru-central1-b → 192.168.50.0/24
ru-central1-d → 192.168.60.0/24
```

Worker-ноды не имеют публичных IP. Доступ в интернет осуществляется через NAT Gateway.


### Service Account

Для Kubernetes создан отдельный Service Account:

```text
sa-k8s
```

Назначены роли:

```text
k8s.clusters.agent
vpc.publicAdmin
kms.keys.encrypterDecrypter
load-balancer.admin
```

Для worker-нод используется:

```text
sa-k8s-node
```

с ролью:

```text
container-registry.images.puller
```

### KMS

Для шифрования используется существующий ключ KMS:

```text
storage_key
```

В Terraform:

```hcl
kms_provider {
  key_id = var.kubernetes.kms_key_id
}
```

### Node Group

Создана группа:

```text
k8s-nodes
```

Параметры:

```text
Initial nodes: 3
Minimum nodes: 3
Maximum nodes: 6
CPU: 2 cores
RAM: 4 GB
CPU fraction: 100%
Disk: 64 GB
Disk type: network-hdd
```

Включено автоматическое масштабирование:

```text
3 → 6 nodes
```

### Важный нюанс

Yandex Cloud не позволил создать одну autoscaling Node Group с несколькими зонами размещения. Поэтому:

- Kubernetes Master размещён в трёх зонах;
- worker Node Group с autoscaling 3–6 использует одну зону;
- доступ worker-нод в интернет обеспечивается через NAT Gateway.

## 3. phpMyAdmin

В Kubernetes создан namespace:

```text
test
```

В нём развёрнут phpMyAdmin:

```text
Deployment: phpmyadmin
Replicas: 1
Image: phpmyadmin:latest
```

Для подключения к MySQL используется Kubernetes Secret.

В Secret передаются:

```text
PMA_HOST
PMA_PORT
PMA_USER
PMA_PASSWORD
```

Хост MySQL передаётся из Terraform:
```hcl
module.mysql.fqdn[0]
```

## 4. LoadBalancer

Для phpMyAdmin создан Kubernetes Service:

```text
phpmyadmin
```

Тип:

```text
LoadBalancer
```

Параметры:

```text
Port: 80
TargetPort: 80
```

После назначения роли:

```text
load-balancer.admin
```

Yandex Cloud успешно создал внешний Load Balancer.

Публичный IP:

```text
158.160.214.41
```

phpMyAdmin доступен:

```text
http://158.160.214.41
```

## 7. Основные Terraform-модули

### VPC

```text
modules/vpc
```

Создаёт:

- VPC Network;
- Subnets;
- NAT Gateway;
- Route Tables;
- Security Groups.

### MySQL

```text
modules/mysql
```

Создаёт:

- MySQL Cluster;
- Database;
- User.

### Service Account

```text
modules/service-account
```

Создаёт Service Account и назначает IAM-роли.

### Kubernetes

```text
modules/k8s
```

Создаёт:

- Managed Kubernetes Cluster;
- Regional Master;
- Node Group;
- Autoscaling;
- KMS configuration.

### phpMyAdmin

```text
modules/phpmyadmin
```

Создаёт:

- Kubernetes Secret;
- Deployment;
- Service типа `LoadBalancer`.
