variable "env" {
  description = "Name of Environment"
  type        = string
}

variable "create_vpc" {
  description = ""
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = ""
  type        = string
  default     = ""
}

variable "create_endpoint_cloudwatch_logs" {
  description = ""
  type        = bool
  default     = true
}

variable "create_endpoint_kinesis" {
  description = ""
  type        = bool
  default     = true
}

variable "create_endpoint_ssm" {
  description = ""
  type        = bool
  default     = true
}

variable "create_endpoint_codedeploy" {
  description = ""
  type        = bool
  default     = true
}

variable "create_endpoint_sns" {
  description = ""
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "CIDR Block of VPC"
  type        = string
  default     = ""
}

variable "subnet_public_list" {
  description = "List of subnet for public"

  type = list(object({
    az   = string
    cidr = string
  }))

  default = []
}

variable "subnet_private_list" {
  description = "List of subnet for private"

  type = list(object({
    az   = string
    cidr = string
  }))

  default = []
}

variable "create_nat_gateway" {
  description = ""
  type        = bool
  default     = true
}
