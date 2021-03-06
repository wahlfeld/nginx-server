variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "The AWS region to create the nginx server"
}

variable "instance_type" {
  type        = string
  default     = "t3a.nano"
  description = "AWS EC2 instance type to run the server on"
}

variable "purpose" {
  type        = string
  default     = "prod"
  description = "The purpose of the deployment"
}

variable "unique_id" {
  type        = string
  default     = ""
  description = "The ID of the deployment (used for tests)"
}
