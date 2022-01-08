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
  region  = "us-east-2"
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDlbAv/HcXI3GH6OlzYIaZH5BRBBwvkoMYoi6Re2TBCeoU36MFWs6vV8nrOm06vPzSWh+fObNC2fqsEtqCJMJ9x0yZv86rla9A4B8YO+VN/uMnfT/dBM+xbg63meNBCVKiY/h3KaGGD9CO/cBuuuiijPmAHKpRzkhvTPRjnDwf91+sj2tpikR5hl1Xc5Auk0sn9/wpq/AcUn4ojToNStl+bIfPOwU+hDkZ5t43BPGmazoRiT5XtdVAt79Obj1hE0GKyOO4ercBT1FjeYcG7pGlKcJB4fziK4u5gfLziQYBQB1qHDRHjz3fJR/UX6+mze1BCSoUI2NFxFqVUKPDqN6FfnBFfnGyVZkPdgLvbFn7Piz/GKpks1vYDEbFubo+3nrqPwYXGjO1hqz3Xy5+d5dWkr2ObOEFLbd6mRu1QN+aMDgvJVpG2dkFvknJHHJR72gxmVp66lNE4oJ1ACF621f4CatkpLXoky0V7Xzsc6f6VYBOhiKbfBCKMJ0rrInZ+pbs= boinet@MSI"
}

resource "aws_security_group" "allow_SSH" {
  name = "allow_SSH_BOINET"
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
  name = "allow_HTTPD_BOINET"
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