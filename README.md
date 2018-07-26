# terraform-module-peering-vpc

This module provides easy peering procedures between VPCs, especially when those are built
with the official VPC module from the terraform registry (https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/1.34.0).

## Requirements

### `nameOfTheVPC-public` route table

This route is created by terraform when you configure your VPC with a `public_subnets` cidr blocks like this:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.34.0"

  name = "my-vpc"
  cidr = "10.123.0.0/16"

  azs            = "eu-west-1"
  public_subnets = ["10.123.1.0/24", "10.123.2.0/24"]

  // Enable Route 53 support for private zone association
  enable_dns_hostnames = true
  enable_dns_support   = true
}
```

You still have the possibility to target an another route table by specifying its name with this module's arguments:

* `requester_route_table`
* `accepter_route_table`

## Examples

* Simple peering

```hcl
module "peering_ab" {
  source = "github.com/DoubleTrade/terraforum-module-vpc-peering"
  accepter_vpc_name = "my-vpc-a"
  requester_vpc_name = "my-vpc-b"
  tags = {
    Name        = "vpc-a-b"
    Shortname   = "vpc-a-b"
    Terraform   = true
    Env         = "Prod"
    Description = "Peering from VPC A to VPC B"
  }
}
```

* With specified route tables

```hcl
module "peering_ab" {
  source                = "github.com/DoubleTrade/terraforum-module-vpc-peering"
  accepter_vpc_name     = "my-vpc-a"
  requester_vpc_name    = "my-vpc-b"
  requester_route_table = "my-custom-route-table"

  tags = {
    Name        = "vpc-a-b"
    Shortname   = "vpc-a-b"
    Terraform   = true
    Env         = "Prod"
    Description = "Peering from VPC A to VPC B"
  }
}
```

```hcl
module "peering_ab" {
  source                = "github.com/DoubleTrade/terraforum-module-vpc-peering"
  accepter_vpc_name     = "my-vpc-a"
  accepter_route_table  = "my-custom-route-table-a"
  requester_vpc_name    = "my-vpc-b"
  requester_route_table = "my-custom-route-table-a"

  tags = {
    Name        = "vpc-a-b"
    Shortname   = "vpc-a-b"
    Terraform   = true
    Env         = "Prod"
    Description = "Peering from VPC A to VPC B"
  }
}

We suppose route tables name are unique in a same VPC.