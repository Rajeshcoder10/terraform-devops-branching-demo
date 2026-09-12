# 1. Basic string variable with a default value
variable "aws_region" {
  type        = string
  description = "The target AWS region for resource deployment."
  default     = "us-east-1"
}
