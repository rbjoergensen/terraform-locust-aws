resource "aws_instance" "master" {
  private_ip      = var.master_ip
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.terraform-keypair.key_name
  subnet_id       = data.aws_subnet.private-subnet-1.id
  security_groups = [ aws_security_group.main.id ]

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
      user        = "ubuntu"
      private_key = file("ec2-keypair-terraform.ppk")
      host        = self.private_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /tmp/setup.sh",
      "sudo mv /tmp/tasks.py /locust/",
      "sudo mv /tmp/locust-master.service /etc/systemd/system/locust.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart locust"
    ]

    connection {
      user        = "ubuntu"
      private_key = file("ec2-keypair-terraform.ppk")
      host        = self.private_ip
    }
  }
}