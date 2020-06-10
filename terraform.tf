terraform {
 backend "s3" {
   encrypt = true
   bucket = "terraform-remote-state-storage-s3-cotv"
   dynamodb_table = "terraform-state-lock-dynamo"
   region = "eu-central-1"
   key = "locustio-ec2/terraform.tfstate"
 }
}