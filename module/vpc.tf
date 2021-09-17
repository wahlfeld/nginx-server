resource "aws_vpc" "nginx" {
  #checkov:skip=CKV2_AWS_1:We don't need NACLs as security groups are sufficient
  #checkov:skip=CKV2_AWS_11:VPC flow logging is an extra cost and unecessary for this implementation
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = merge(local.tags,
    {
      "Name" = local.name
    }
  )
}

resource "aws_default_security_group" "nginx" {
  vpc_id = aws_vpc.nginx.id
}

resource "aws_internet_gateway" "nginx" {
  vpc_id = aws_vpc.nginx.id
  tags = merge(local.tags,
    {
      "Name" = local.name
    }
  )
}

data "aws_route_table" "nginx" {
  vpc_id = aws_vpc.nginx.id
}

resource "aws_route" "nginx" {
  route_table_id         = data.aws_route_table.nginx.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nginx.id
}


resource "aws_subnet" "nginx" {
  #checkov:skip=CKV_AWS_130:We want public IPs to be assigned by default
  vpc_id                  = aws_vpc.nginx.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = merge(local.tags,
    {
      "Name" = local.name
    }
  )
}
