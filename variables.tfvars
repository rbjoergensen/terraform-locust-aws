master_ip      = "192.168.2.100"
vpc_id         = "vpc-0000000000000000"
subnet_id      = "subnet-0000000000000000"
key_name       = "ec2-keypair-terraform-frankfurt"
key_value      = "ssh-rsa AAAH8****== ec2-keypair-terraform"
sg_name        = "Locust SG"
sg_description = "Security group for locust instances"
worker_count   = 3
ami_id         = "ami-0b418580298265d5c" #Ubuntu Server 18.04 LTS (HVM), SSD Volume Type
instance_type  = "t2.micro" # t2.micro(free-1/1), t3a.medium(2/4), c5.xlarge(4/8)
volume_type    = "gp2"
volume_size    = "25"
tags           = ["Locustio", "Test", "Loadtest", "DevOps"] # Name, Environment, Category, Department
