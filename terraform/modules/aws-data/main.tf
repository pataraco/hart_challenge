##############################################################
# Data sources to get VPC, subnets, security group and AMI details
##############################################################
data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.vpc_name}"
    Environment = "${upper(var.env)}"
  }
}
data "aws_subnet_ids" "private" {
  tags = {
    Network = "Private"
    Name = "Private Subnet*"
  }
  vpc_id = "${data.aws_vpc.vpc.id}"
}
data "aws_security_group" "alb" {
  count = "${var.alb_needed == "true" ? 1: 0}"
  vpc_id = "${data.aws_vpc.vpc.id}"
  filter {
    name   = "group-name"
    values = ["${var.app}-${var.env}-${var.tier}-alb"]
  }
}
data "aws_security_group" "tier" {
  filter {
    name   = "group-name"
    values = ["${var.app}-${var.env}-${var.tier}"]
  }
  vpc_id = "${data.aws_vpc.vpc.id}"
}
data "aws_security_groups" "globals" {
  filter {
    name   = "group-name"
    values = ["*global*"]
  }
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
  tags = {
    Environment = "${upper(var.env)}"
  }
}
data "aws_kms_key" "ebs" {
  key_id = "alias/${var.app}-${var.env}-global-ebs"
}
data "aws_ssm_parameter" "ami" {
  name = "${var.app}-${var.env}-ami"
}

data "aws_ssm_parameter" "ami_linux" {
  name = "${var.app}-${var.env}-ami-linux"
}
