variable "name" {
  description = "The name of the Application Load Balancer"
  type        = string
}

variable "internal" {
  description = "Whether the load balancer is internal"
  type        = bool
  default     = false
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of public subnet IDs where the ALB will be deployed"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the ALB"
  type        = map(string)
  default     = {}
}
variable "listener_http" {
  description = "Enable HTTP listener"
  type        = bool
  default     = true
}

variable "listener_https" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS (required if listener_https is true)"
  type        = string
  default     = ""
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port on which the target group will receive traffic"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "The VPC ID where the ALB and target group will reside"
  type        = string
}
variable "default_sg" {
  description = "Create a default security group for the ALB"
  type        = bool
  default     = true
}

variable "default_sg_ingress_rules" {
  description = "Ingress rules for the default security group"
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr_blocks  = list(string)
  }))
  default = [
    {
      description = "Allow HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow HTTPS"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "default_sg_egress_rules" {
  description = "Egress rules for the default security group"
  type = list(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr_blocks  = list(string)
  }))
  default = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
