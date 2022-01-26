locals {
  subnet_ids          = contains(["MULTI_AZ_1"], var.deployment_type) ? [var.subnet_ids[0], var.subnet_ids[1]] : [var.subnet_ids[0]]
  preferred_subnet_id = contains(["MULTI_AZ_1"], var.deployment_type) ? var.subnet_ids[0] : null
  kms_key_id          = var.create_kms_key == false ? var.kms_key_arn : aws_kms_key.this[0].arn
  security_group_ids  = concat(var.security_group_ids, [aws_security_group.this.id])
}
