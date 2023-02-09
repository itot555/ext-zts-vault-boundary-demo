variable "region" {
  description = "AWS region (default: Singapore)"
  type        = string
  default     = "ap-southeast-1"
}

variable "instances" {
  default = [
    "boundary-ec2-lin-1",
    "boundary-ec2-lin-2",
    "boundary-ec2-lin-3",
    "boundary-ec2-lin-4"
  ]
}

variable "db_password" {}