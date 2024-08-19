variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "eu-central-1"
}

variable "ami" {
  type    = string 
  default = "ami-015c25ad8763b2f11"
}

variable "aws_s3_bucket" {
  type    = string 
  default = "dev-codedeploy-bucket"
}

variable "public_key" {
  description = "ssh public key"
}

variable "email" {
  description = "your email address"
}