resource "aws_security_group" "ssh" {
  name   = "ssh_target"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "postgres" {
  name_prefix = "postgres_target"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
/*
resource "aws_security_group" "rdp" {
  name_prefix = "rdp_target"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
*/
resource "aws_security_group" "kube" {
  name_prefix = "kube_target"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
/*
resource "aws_security_group" "worker" {
  name_prefix = "boundary_worker"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 9202
    to_port   = 9202
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}*/