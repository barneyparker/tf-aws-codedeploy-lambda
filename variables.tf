# CodeDeploy Parameters
variable "application_name" {}

variable "application_group" {}

variable "deployment_config" {
  description = "pre-defined Application Deployment Config"
  default     = ""
}

variable "deployment_interval" {
  description = "Custom Application Deployment Config Interval between updates"
  default     = "1"
}

variable "deployment_percentage" {
  description = "Custom Application Deployment Config Percentage change at each interval"
  default     = "50"
}

variable "deployment_role_arn" {
  default = ""
}


# Lambda Parameters
variable "lambda_name" {}

variable "runtime" {}

variable "handler" {}

variable "memory_size" {
  default = "128"
}

variable "timeout" {
  default = "3"
}

variable "description" {
  default = ""
}



variable "env_vars" {
  default = {
    "foo" = "bar"
  }
}

variable "aliases" {
  type = "list"
  description = "list of alias names"
}
