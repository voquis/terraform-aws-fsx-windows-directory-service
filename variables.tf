# Required variables
variable "ad_security_group_id" {
  type        = string
  description = "Managed AD security group id"
}

variable "directory_id" {
  type        = string
  description = "Managed AD directory id"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids to create resources. Only two subnets may be supplied."
}

variable "vpc_id" {
  type        = string
  description = "VPC to create security group and FSx"
}

# Optional variables
variable "security_group_ids" {
  type        = list(string)
  description = "(optional) Additional security groups to attach to FSx. Note that a security group will be created for communication with AD."
  default     = []
}

variable "name" {
  type        = string
  description = "(optional) FSx name"
  default     = "FSx for Windows"
}

variable "storage_capacity" {
  type        = number
  description = "(optional) Storage capacity"
  default     = 320
}

variable "throughput_capacity" {
  type        = number
  description = "(optional) Throughput capacity"
  default     = 16
}

variable "automatic_backup_retention_days" {
  type        = number
  description = "(optional) Automatic backup retention in days"
  default     = 7
}

variable "weekly_maintenance_start_time" {
  type        = string
  description = "(optional) Weekly maintenance start time"
  default     = "6:04:00"
}

variable "deployment_type" {
  type        = string
  description = "(optional) Deployment type"
  default     = "SINGLE_AZ_1"
}

variable "storage_type" {
  type        = string
  description = "(optional) Storage type"
  default     = "SSD"
}

variable "skip_final_backup" {
  type        = bool
  description = "(optional) Whether to skip final backup before deletion"
  default     = true
}

variable "fsx_to_ad_udp_ports" {
  type        = list(string)
  description = "(optional) UDP ports numbers needed for FSx to communicate with Active Directory"
  default     = ["53", "88", "123", "389", "464"]
}

variable "fsx_to_ad_tcp_ports" {
  type        = list(string)
  description = "(optional) TCP ports numbers needed for FSx to communicate with Active Directory"
  default     = ["53", "88", "135", "389", "445", "464", "636", "3268", "3269", "5985", "9389", "49152-65535"]
}

# KMS key settings
variable "create_kms_key" {
  type        = bool
  description = "(optional) Whether a KMS key for FSx encryption should be created."
  default     = true
}

variable "kms_key_arn" {
  type        = string
  description = "(optional) If a KMS key for FSx encyrption should not be created, the KMS key arn to use. Requires that `create_kms_key` be set to `false`"
  default     = null
}

variable "kms_key_description" {
  type        = string
  description = "(optional) KMS key description if this module is creating the resource"
  default     = "FSx"
}

variable "kms_key_deletion_window_in_days" {
  type        = number
  description = "(optional) KMS key deletion window in days if this module is creating the resource"
  default     = 10
}

variable "kms_key_usage" {
  type        = string
  description = "(optional) KMS key usage if this module is creating the resource"
  default     = "ENCRYPT_DECRYPT"
}

variable "kms_key_customer_master_key_spec" {
  type        = string
  description = "(optional) KMS key customer master key spec if this module is creating the resource"
  default     = "SYMMETRIC_DEFAULT"
}
