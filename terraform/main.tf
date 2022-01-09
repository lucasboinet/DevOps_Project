terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
  shared_credentials_file = "./credentials"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0d97ef13c06b05a19"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name = "deployer-key-boinet"
  vpc_security_group_ids = [ aws_security_group.allow_SSH.id, aws_security_group.allow_HTTPD.id ]
  user_data = templatefile("scripts/add-ssh-web-app.yaml",{})

  tags = {
    Name   = var.instance_name,
    Groups = "app",
    Owner  = "Boinet-Lucas"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-boinet"
  public_key = file("./ssh/id_deployer_key.pub")
}

resource "aws_security_group" "allow_SSH" {
  name = "allow_SSH"
  description = "Allow ssh"

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name   = var.instance_name,
    Groups = "app",
    Owner  = "Boinet-Lucas"
  }
}

resource "aws_security_group" "allow_HTTPD" {
  name = "allow_HTTPD"
  description = "Allow httpd"

  ingress {
    description = "httpd"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name   = var.instance_name,
    Groups = "app",
    Owner  = "Boinet-Lucas"
  }
}