variable "region" {
  description = "AWS region to use"
}

variable "instance_type" {
  description = "EC2 instance type (default: t2.nano)"
  default     = "t2.nano"
}
