# Terraform peering_monitoring

## Requirements

### `nameOfTheVPC-public` route table

This route is created by terraform when you configure youir VPC with public cidr blocks like this:

```
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

You still have the possibility to target an another route table by specifying its name with those module arguments:

* `requester_route_table`
* `accepter_route_table`

## Examples