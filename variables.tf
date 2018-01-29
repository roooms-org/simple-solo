variable "region" {
  description = "AWS region to use"
}

variable "config_name" {
  description = "Unique configuration name"
}

variable "instance_type" {
  description = "EC2 instance type (default: t2.nano)"
  default     = "t2.nano"
}
