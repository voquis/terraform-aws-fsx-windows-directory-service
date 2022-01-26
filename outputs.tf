output "fsx_windows_file_system" {
  value = aws_fsx_windows_file_system.this
}

output "security_group" {
  value = aws_security_group.this
}

output "aws_kms_key" {
  value = aws_kms_key.this
}
