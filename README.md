# Terraform module for AWS FSx for Windows with Active Directory
Creates an FSx for Windows File system share attached to Managed AD.
Creates and exports a security group with rules to communicate with Managed AD for domain joining

## Examples
### Simple example
It is assumed a Managed AD directory has already been created, for example with [voquis/directory-service-with-logging](https://registry.terraform.io/modules/voquis/directory-service-with-logging/aws/latest) in addition to a VPC, for example with [voquis/vpc-subnets-internet](https://registry.terraform.io/modules/voquis/vpc-subnets-internet/aws/latest).

```terraform
module "fsx" {
  source  = "voquis/fsx-windows-directory-service/aws"
  version = "0.0.1"

  ad_security_group_id = module.ad.directory_service_directory.security_group_id
  directory_id         = module.ad.directory_service_directory.id

  subnet_ids   = [
    module.vpc.subnets[1].id,
    module.vpc.subnets[2].id,
  ]

  vpc_id = module.vpc.vpc.id
}

```
