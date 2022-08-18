# load config file
locals {
  input_file         = "./config.yml"
  input_file_content = fileexists(local.input_file) ? file(local.input_file) : "NoInputFileFound: true"
  input              = yamldecode(local.input_file_content)
}


terraform {
  backend "s3" { # Define a remote bucket (AWS S3)

  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = local.input.access.region
  access_key = local.input.access.access_key
  secret_key = local.input.access.secret_key
}


data "aws_vpc" "selected" {
  state = "available"
  default = true
}

resource "aws_security_group" "public" {
  count = length(local.input.security_groups)
  name        = local.input.security_groups[count.index].name
  description = local.input.security_groups[count.index].description
  vpc_id      = data.aws_vpc.selected.id


  dynamic "ingress" {
    for_each = local.input.security_groups[count.index].rules
    content {
      from_port        = ingress.value["port"]
      to_port          = ingress.value["port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks       = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    ManagedBy   = "terraform"
  }
  # tags = { for index, tag in local.input.security_groups[0].tags : (tag.key) => tag.value}
}


# print result 
# output "rules" {
  # for_each      = toset(local.input.security_groups[0].rules)
  # value = {
  #   rule     = each 
  # }
  # value = { for index, tag in local.input.security_groups[0].tags : (tag.key) => tag.value}
# }