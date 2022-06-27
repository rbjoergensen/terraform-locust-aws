variable "locust_name" {
  type = string
  default = ""
}

variable "ip_whitelist" {
  type = list(string)
  default = [ "0.0.0.0/0" ]
}

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
