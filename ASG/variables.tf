variable "alb_max_size" {
  type        = number
  description = "Max number of instances"
  default     = 3
}

variable "alb_min_size" {
  type        = number
  description = "Minimum number of instances"
  default     = 2
}

variable "alb_desired_size" {
  type        = number
  description = "Desired number of instances"
  default     = 2
}

variable "image_id" {
  type        = string
  description = "AMI ID"
  default     = "ami-0453ec754f44f9a4a" # Replace with dynamic fetching
}

variable "image_type" {
  type        = string
  description = "Instance type"
  default     = "t2.micro"
}

variable "public_ip" {
  type        = bool
  description = "Associate Public IP"
  default     = false
}