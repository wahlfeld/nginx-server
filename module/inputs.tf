variable "aws_region" { type = string }
variable "instance_type" { type = string }
variable "purpose" { type = string }
variable "unique_id" { type = string }

locals {
  tags = {
    "Purpose"   = var.purpose
    "CreatedBy" = "Terraform"
  }
  ec2_tags = merge(local.tags,
    {
      "Name"        = "${local.name}-server"
      "Description" = "Instance running a nginx server"
    }
  )
  name = var.purpose != "prod" ? "nginx-${var.purpose}${var.unique_id}" : "nginx"
}
