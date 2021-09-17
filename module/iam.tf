resource "aws_iam_role" "nginx" {
  name = local.name
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : "sts:AssumeRole",
        Principal : {
          Service : "ec2.amazonaws.com"
        },
        Effect : "Allow",
        Sid : ""
      }
    ]
  })
  tags = local.tags
}

resource "aws_iam_instance_profile" "nginx" {
  role = aws_iam_role.nginx.name
}

resource "aws_iam_policy" "nginx" {
  name        = local.name
  description = "Allows the nginx server to interact with various AWS services"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : ["ec2:DescribeInstances"],
        Resource : ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "nginx" {
  role       = aws_iam_role.nginx.name
  policy_arn = aws_iam_policy.nginx.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.nginx.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
