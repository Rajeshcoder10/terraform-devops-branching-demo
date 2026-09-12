variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The size of the EC2 instance"
  type        = string
  default     = "t2.micro"
}