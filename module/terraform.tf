terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.19.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "=2.11.0"
    }
  }
}