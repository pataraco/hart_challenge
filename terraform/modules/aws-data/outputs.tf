output "aws_vpc_id" {
  description = "vpc ID"
  value = "${data.aws_vpc.vpc.id}"
}
output "aws_subnet_ids_private" {
  description = "Private subnet IDs"
  value = ["${data.aws_subnet_ids.private.ids}"]
}
output "aws_security_group_alb" {
  description = "ALB Security group for the tier"
  # value = "${data.aws_security_group.alb.*.id[0]}"
  # value = "${length(data.aws_security_group.alb.*.id) == 0 ? "" : data.aws_security_group.alb.*.id[0]}"
  # value = "${0 == 0 ? "" : element(data.aws_security_group.alb.*.id,0)}"
  value = "${coalesce(join(",", data.aws_security_group.alb.*.id), "not looked up")}"
}
output "aws_security_group_tier" {
  description = "Security groups for tiers"
  value = "${data.aws_security_group.tier.id}"
}
output "aws_security_group_globals" {
  description = "Security groups for global"
  value = "${data.aws_security_groups.globals.ids}"
}
output "aws_kms_key_ebs" {
  description = "ebs KMS key"
  value = "${data.aws_kms_key.ebs.arn}"
}
output "aws_ssm_parameter_ami" {
  description = "SSM param ami store"
  value = "${data.aws_ssm_parameter.ami.value}"
}

output "aws_ssm_parameter_ami_linux" {
  description = "SSM param ami linux store"
  value = "${data.aws_ssm_parameter.ami_linux.value}"
}
