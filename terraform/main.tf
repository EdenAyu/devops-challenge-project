# terraform {
#   backend "s3" {
#     bucket  = "eg-s3bucket-challenge"
#     key     = "e.g/terraform.tfstate"
#     region  = "us-west-2"
#     profile = "default"
#   }
# }

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_route53_zone" "selected" {
  name = "bwtcdevopschallenge.com."
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-traffic"
  description = "Allow ssh traffic on port 22"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "myKey"
  public_key = ""
}

resource "aws_instance" "web" {
  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh.id}",
  ]
  # subnet_id     = "subnet-032494020f229850d"
  ami                  = "ami-0ca285d4c2cda3300"
  instance_type        = "t3.micro"
  key_name             = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  tags = {
    Name = "devops-challenge"
  }
}

resource "aws_s3_bucket" "bucket_creation" {
  bucket        = "eg-s3bucket-challenge"
  force_destroy = true
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "eg.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.web.public_ip]
}

resource "aws_iam_policy" "policy" {
  name        = "policy-to-assign"
  description = "policy to attach"
  policy      = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.bucket_creation.bucket}",
                    "arn:aws:s3:::${aws_s3_bucket.bucket_creation.bucket}/*"]
    }
  ]
}
  EOT
}

resource "aws_iam_role" "S3ReadWrite" {
  name = "S3ReadWrite"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2-attachment"
  roles      = [aws_iam_role.S3ReadWrite.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.S3ReadWrite.name
}

