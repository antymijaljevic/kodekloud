variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "region"
}

variable "ami" {
  type        = string
  default     = "ami-06178cf087598769c"
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  default     = "m5.large"
  description = "AWS Instance Type"
}