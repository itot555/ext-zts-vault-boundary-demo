# Provisioning AWS resources

TFC workspace: `zts-demo_aws`

## Contents

- [Configure demodb](#configure-demodb)
- [References](#references)

# Configure demodb

Insert demo data with `setup_demodb.sql`.

```
psql -h <hostname> -p 5432 -U <username> --password --dbname=demodb -f ./setup_demodb.sql
```

Confirm database.

```
psql -h <hostname> -p 5432 -U <username> --password --dbname=demodb
```
```sql
demodb=> \d
         List of relations
 Schema | Name  | Type  |  Owner
--------+-------+-------+----------
 public | stand | table | boundary
(1 row)
```
```sql
demodb=> select * from stand;
 id |  name  |      stand
----+--------+-----------------
  3 | jotaro | star platinum
  4 | josuke | crazy diamond
  5 | giorno | gold experience
  6 | jorin  | stone free
  7 | jonny  | act three
  8 | josuke | soft and wet
(6 rows)
```

Create role on target database.

```
psql -h <hostname> -p 5432 -U <username> --password --dbname=demodb
```

Role `ro_demodb` with SELECT permission.

```sql
demodb=> CREATE ROLE ro_demodb noinherit;
CREATE ROLE
```
```sql
demodb=> GRANT SELECT ON ALL TABLES IN SCHEMA public TO "ro_demodb";
GRANT
```

Role `rw_demodb` with ALL permission.

```sql
demodb=> CREATE ROLE rw_demodb noinherit;
CREATE ROLE
```
```sql
demodb=> GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "rw_demodb";
GRANT
```

# References

## AWS Provider

- [Provision an EKS Cluster (AWS)](https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks)
- [Resource: aws_db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [Resource: aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Resource: aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
- [Resource: aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [Terraform module to create an Elastic Kubernetes (EKS) cluster and associated resources](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/18.26.6)
- [Terraform module which creates EC2 instance(s) on AWS](https://registry.terraform.io/modules/terraform-aws-modules/ec2-instance/aws/latest)
- [Terraform module which creates VPC resources on AWS](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/3.14.2)

## Kubernetes Provider

- [Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Manage Kubernetes Custom Resources](https://developer.hashicorp.com/terraform/tutorials/kubernetes/kubernetes-crd-faas)

## TLS Provider

- [tls_private_key (Resource)](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key)