provider "aws" {
  region  = "us-east-1"
  profile = "AWSiA"
}

data "terraform_remote_state" "key_pair_us_east_1" {
  backend = "local"

  config {
    path = "${path.module}/../../mgmt/key-pairs/us-east-1/terraform.tfstate"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_machine" {
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.ssh_only.id}"]
  key_name               = "${data.terraform_remote_state.key_pair_us_east_1.aws_personal_key_pair}"

  tags {
    Name = "my-machine"
  }
}

resource "aws_security_group" "ssh_only" {
  name        = "ssh-only"
  description = "Allow SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ssh-only"
  }
}
