#tfsec:ignore:AWS018
resource "aws_security_group" "ingress" {
  #checkov:skip=CKV2_AWS_5:Broken - https://github.com/bridgecrewio/checkov/issues/1203
  vpc_id = aws_vpc.nginx.id
  tags = merge(local.tags,
    {
      "Name"        = "${local.name}-ingress"
      "Description" = "Security group allowing inbound traffic to the nginx server"
    }
  )
}

resource "aws_security_group_rule" "nginx_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.ingress.id
  description       = "Allows traffic to the nginx server"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "netdata" {
  type              = "ingress"
  from_port         = 19999
  to_port           = 19999
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.ingress.id
  description       = "Allows traffic to the Netdata dashboard"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "nginx_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.ingress.id
  description       = "Allow all egress rule for the nginx server"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "nginx" {
  most_recent = true
  # for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); \
  #   do aws ec2 describe-images --region $region --owners amazon \
  #   --filters "Name=name,Values=aws-elasticbeanstalk-amzn-*64bit-eb_docker_amazon_linux_2-hvm-*" \
  #   --query 'Images[*].[OwnerId]' --output text | uniq; done
  owners = [
    "400192859621",
    "536084292650",
    "844681662233",
    "536662048057",
    "937922282355",
    "362719791414",
    "153470706256",
    "746694360614",
    "372448324479",
    "493648851110",
    "771557761935",
    "964913206263",
    "672235430477",
    "052272138977",
    "971594493945",
    "430718571600",
    "732788773938",
  ]
  filter {
    name   = "name"
    values = ["aws-elasticbeanstalk-amzn-*64bit-eb_docker_amazon_linux_2-hvm-*"]
  }
}

resource "aws_spot_instance_request" "nginx" {
  #checkov:skip=CKV_AWS_126:Detailed monitoring is an extra cost and unecessary for this implementation
  #checkov:skip=CKV_AWS_8:This is not a launch configuration
  ami                            = data.aws_ami.nginx.id
  instance_type                  = var.instance_type
  ebs_optimized                  = true
  user_data                      = file("${path.module}/local/userdata.sh")
  iam_instance_profile           = aws_iam_instance_profile.nginx.name
  vpc_security_group_ids         = [aws_security_group.ingress.id]
  subnet_id                      = aws_subnet.nginx.id
  wait_for_fulfillment           = true
  instance_interruption_behavior = "stop"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = local.ec2_tags
}

output "instance_id" {
  value = aws_spot_instance_request.nginx.spot_instance_id
}

resource "aws_ec2_tag" "nginx" {
  for_each = local.ec2_tags

  resource_id = aws_spot_instance_request.nginx.spot_instance_id
  key         = each.key
  value       = each.value
}

output "nginx_url" {
  value = format("%s%s", "http://", aws_spot_instance_request.nginx.public_dns)
}

output "monitoring_url" {
  value = format("%s%s%s", "http://", aws_spot_instance_request.nginx.public_dns, ":19999")
}
