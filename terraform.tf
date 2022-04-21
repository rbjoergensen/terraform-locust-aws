provider "aws" {
  region   = "eu-central-1"
  version  = "2.48.0"
}

terraform {
 backend "s3" {
   encrypt = true
   bucket = "terraform-remote-state-storage-s3-cotv"
   dynamodb_table = "terraform-state-lock-dynamo"
   region = "eu-central-1"
   key = "locustio-ec2/terraform.tfstate"
 }
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
