resource "aws_fsx_windows_file_system" "this" {
  active_directory_id = var.directory_id
  storage_capacity    = var.storage_capacity
  # At most 2 subnets are allowed. If SINGLE_AZ_1 only one subnet may be specified.
  subnet_ids                      = local.subnet_ids
  throughput_capacity             = var.throughput_capacity
  automatic_backup_retention_days = var.automatic_backup_retention_days
  weekly_maintenance_start_time   = var.weekly_maintenance_start_time
  deployment_type                 = var.deployment_type
  storage_type                    = var.storage_type
  preferred_subnet_id             = local.preferred_subnet_id
  kms_key_id                      = local.kms_key_id
  skip_final_backup               = var.skip_final_backup
  security_group_ids = [
    aws_security_group.this.id
  ]

  tags = {
    Name = var.name
  }

  timeouts {
    delete = "60m"
  }

  depends_on = [
    aws_security_group_rule.udp_fsx_egress_to_active_directory,
    aws_security_group_rule.udp_active_directory_ingress_from_fsx,
    aws_security_group_rule.tcp_fsx_egress_to_active_directory,
    aws_security_group_rule.tcp_active_directory_ingress_from_fsx,
  ]
}

# FSx to AD security group rules
# UDP 53,88,123,389,464
# TCP 53,88,135,389,445,464,636,3268,3269
# See:
# https://docs.aws.amazon.com/fsx/latest/WindowsGuide/aws-ad-integration-fsxW.html
# https://docs.aws.amazon.com/fsx/latest/WindowsGuide/limit-access-security-groups.html
resource "aws_security_group" "this" {
  name        = "fsx"
  description = "fsx"
  vpc_id      = var.vpc_id
}

# UDP rules from FSx egress to AD
resource "aws_security_group_rule" "udp_fsx_egress_to_active_directory" {
  for_each                 = toset(var.fsx_to_ad_udp_ports)
  type                     = "egress"
  from_port                = each.value
  to_port                  = each.value
  protocol                 = "UDP"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.ad_security_group_id
}

# UDP rules from FSx to ingress AD
resource "aws_security_group_rule" "udp_active_directory_ingress_from_fsx" {
  for_each                 = toset(var.fsx_to_ad_udp_ports)
  type                     = "ingress"
  from_port                = length(split("-", each.value)) > 1 ? split("-", each.value)[0] : each.value
  to_port                  = length(split("-", each.value)) > 1 ? split("-", each.value)[1] : each.value
  protocol                 = "UDP"
  security_group_id        = var.ad_security_group_id
  source_security_group_id = aws_security_group.this.id
}

# TCP rules from FSx egress to AD
resource "aws_security_group_rule" "tcp_fsx_egress_to_active_directory" {
  for_each                 = toset(var.fsx_to_ad_tcp_ports)
  type                     = "egress"
  from_port                = length(split("-", each.value)) > 1 ? split("-", each.value)[0] : each.value
  to_port                  = length(split("-", each.value)) > 1 ? split("-", each.value)[1] : each.value
  protocol                 = "TCP"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.ad_security_group_id
}

# TCP rules from FSx to ingress AD
resource "aws_security_group_rule" "tcp_active_directory_ingress_from_fsx" {
  for_each                 = toset(var.fsx_to_ad_tcp_ports)
  type                     = "ingress"
  from_port                = length(split("-", each.value)) > 1 ? split("-", each.value)[0] : each.value
  to_port                  = length(split("-", each.value)) > 1 ? split("-", each.value)[1] : each.value
  protocol                 = "TCP"
  security_group_id        = var.ad_security_group_id
  source_security_group_id = aws_security_group.this.id
}

# ---------------------------------------------------------------------------------------------------------------------
# Optionally create KMS Key for FSx encryption
# Provider docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_kms_key" "this" {
  count                    = var.create_kms_key == true ? 1 : 0
  description              = var.kms_key_description
  deletion_window_in_days  = var.kms_key_deletion_window_in_days
  key_usage                = var.kms_key_usage
  customer_master_key_spec = var.kms_key_customer_master_key_spec
}
