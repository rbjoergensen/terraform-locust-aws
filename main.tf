### Provider ##########################################################
provider "aws" {
  region   = "eu-central-1"
  version  = "2.48.0"
  access_key = var.access_key
  secret_key = var.secret_key
}
### Variables #########################################################
variable "access_key" {}
variable "secret_key" {}
variable "master_ip" {}
variable "vpc_id" {}
variable "subnet_id" {}
variable "key_name" {}
variable "key_value" {}
variable "sg_name" {}
variable "sg_description" {}
variable "worker_count" {}
variable "ami_id" {}
variable "instance_type" {}
variable "volume_type" {}
variable "volume_size" {}
variable "tags" {}
### Data ##############################################################
data "aws_vpc" "cotv-infrastructure-frankfurt" {
  id = var.vpc_id
}
data "aws_subnet" "private-subnet-1" {
  id = var.subnet_id
}
### Resources #########################################################
resource "aws_key_pair" "terraform-keypair" {
  key_name   = var.key_name
  public_key = var.key_value
}
resource "aws_security_group" "security_group" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = data.aws_vpc.digital-infrastructure-frankfurt.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["192.168.2.0/24"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # All protocols
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    Name        = format("%s-SG", var.tags[0])
    Environment = var.tags[1]
    Category    = var.tags[2]
    Department  = var.tags[3]
  }
}
### Instances ########################################################
resource "aws_instance" "master" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.terraform-keypair.key_name
  private_ip      = var.master_ip
  subnet_id       = data.aws_subnet.private-subnet-1.id
  security_groups = [aws_security_group.security_group.id]
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }
  provisioner "file" {
    source      = "scripts/"
    destination = "/tmp"
    connection {
      user             = "ubuntu"
      private_key      = file("ec2-keypair-terraform.ppk")
      host             = self.private_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/setup.sh",
      "sudo mv /tmp/tasks.py /locust/",
      "sudo mv /tmp/actors.csv /locust/",
      "sudo mv /tmp/locust-master.service /etc/systemd/system/locust.service",
      "sudo rm -rf /tmp/*",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart locust"
    ]
    connection {
      user             = "ubuntu"
      private_key      = file("ec2-keypair-terraform.ppk")
      host             = self.private_ip
    }
  }
  tags = {
    Name        = format("%s-master", var.tags[0])
    Environment = var.tags[1]
    Category    = var.tags[2]
    Department  = var.tags[3]
  }
}
resource "aws_instance" "worker" {
  count           = var.worker_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.terraform-keypair.key_name
  subnet_id       = data.aws_subnet.private-subnet-1.id
  security_groups = [aws_security_group.security_group.id]
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }
  provisioner "file" {
    source      = "scripts/"
    destination = "/tmp"
    connection {
      user             = "ubuntu"
      private_key      = file("ec2-keypair-terraform.ppk")
      host             = self.private_ip
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/setup.sh",
      "sudo mv /tmp/tasks.py /locust/",
      "sudo mv /tmp/actors.csv /locust/",
      format("sudo sed -i 's/<master_ip>/%s/g' /tmp/locust-slave.service", var.master_ip),
      "sudo mv /tmp/locust-slave.service /etc/systemd/system/locust.service",
      "sudo rm -rf /tmp/*",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart locust"
    ]
    connection {
      user             = "ubuntu"
      private_key      = file("ec2-keypair-terraform.ppk")
      host             = self.private_ip
    }
  }
  tags = {
    Name        = format("%s-worker-%s", var.tags[0], count.index)
    Environment = var.tags[1]
    Category    = var.tags[2]
    Department  = var.tags[3]
  }
  depends_on = [ aws_instance.master ]
}