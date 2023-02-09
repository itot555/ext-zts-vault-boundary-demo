resource "tls_private_key" "targets" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    //values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "demo" {
  key_name   = "boundary-targets"
  public_key = tls_private_key.targets.public_key_openssh
}

resource "aws_instance" "linux" {
  ami                    = data.aws_ami.ubuntu.id
  count                  = length(var.instances)
  instance_type          = "t2.micro"
  monitoring             = true
  key_name               = aws_key_pair.demo.key_name
  vpc_security_group_ids = [aws_security_group.ssh.id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name        = element(var.instances, count.index)
    Terraform   = "true"
    Environment = "hcp-zts-demo"
  }
}

resource "aws_db_subnet_group" "postgres" {
  name       = "boundary-target-db"
  subnet_ids = module.vpc.public_subnets
  tags = {
    Environment = "hcp-zts-demo"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "boundary-target-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "13.7"
  instance_class         = "db.t3.micro"
  db_name                = "demodb"
  username               = "boundary"
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.postgres.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  publicly_accessible    = true
  apply_immediately      = true
  skip_final_snapshot    = true
  tags = {
    Environment = "hcp-zts-demo"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.31.2"

  cluster_name                    = local.cluster_name
  cluster_version                 = "1.24"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  subnet_ids                      = module.vpc.private_subnets
  vpc_id                          = module.vpc.vpc_id

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["m5.large"]
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  tags = {
    Environment = "hcp-zts-demo"
  }
}

data "aws_eks_cluster_auth" "zts" {
  name = module.eks.cluster_id
}