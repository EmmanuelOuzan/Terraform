terraform {
  # AWS
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}
# Selecting default profile
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
# Creation of secuirty group 
resource "aws_security_group" "opens8080" {
  name        = "allow_8080"
  description = "Allow 8080 access the machine "

  ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TerraformRockes"
  }
}
# Creationg of instance
resource "aws_instance" "instance" {
  ami           = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"

  tags = {
    Name = "Created_By_Terraform!"
  }
}
# Attachment of the secuirty group 
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.opens8080.id
  network_interface_id = aws_instance.instance.primary_network_interface_id 

}
