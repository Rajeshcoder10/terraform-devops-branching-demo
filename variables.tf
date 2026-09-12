# 1. Basic string variable with a default value
variable "aws_region" {
  type        = string
  description = "The target AWS region for resource deployment."
  default     = "us-east-1"
}

# 2. String variable with strict value validation (allowed environments)
variable "environment" {
  type        = string
  description = "The deployment environment name."

  validation {
    # Ensures the value matches one of the items in the allowed list
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "The environment variable must be either 'dev', 'staging', or 'prod'."
  }
}

# 3. String variable with regex validation (enforces a naming convention)
variable "instance_type" {
  type        = string
  description = "The size of the EC2 instance."
  default     = "t3.micro"

  validation {
    # Enforces that the instance type must begin with 't3.'
    condition     = can(regex("^t3\\.", var.instance_type))
    error_message = "Invalid instance type. Only NextGen burstable 't3' family instances are permitted."
  }
}

# 4. A sensitive map variable (hides values like API keys in logs and terminal outputs)
variable "db_credentials" {
  type = map(string)
  description = "Database administrator username and password."
  sensitive   = true

  default = {
    username = "admin_user"
    password = "SuperSecretPassword123!"
  }
}

# 5. Complex structural type (Object) to group related configuration settings
variable "network_settings" {
  type = object({
    vpc_cidr           = string
    enable_dns_support = bool
    public_subnets     = list(string)
  })
  
  description = "Network configuration object."
  
  default = {
    vpc_cidr           = "10.0.0.0/16"
    enable_dns_support = true
    public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  }
}
