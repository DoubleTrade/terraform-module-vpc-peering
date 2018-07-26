variable "aws_region" {
  type        = "string"
  default     = "eu-west-3"
  description = "Accepter AWS region, should be eu-west-3 (Paris)"
}

variable "accepter_route_table" {
  type        = "string"
  default     = ""
  description = "Route table name, will be used to route traffic from/to the peering pair. If left emtpy, the module will target the accepter's VPC public route (vpcname-public)"
}

variable "accepter_vpc_name" {
  type        = "string"
  description = "Accepter VPC name"
}

variable "requester_vpc_name" {
  type        = "string"
  description = "Requester VPC name"
}

variable "requester_route_table" {
  type        = "string"
  default     = ""
  description = "Route table name, will be used to route traffic from/to the peering pairs. If left emtpy, the module will target the requester's VPC public route (vpcname-public)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "A map of tags, those will be applied to the created resources"
}
