/*
  Data
  --  
  here we fetch instanciate existing asset to configure our peering
*/

# Fetch information about Accepter VPC: monitoring
data "aws_vpc" "accepter" {
  filter {
    name   = "tag:Name"
    values = ["${var.accepter_vpc_name}"]
  }
}

# Fetch information about Requestion VPC
data "aws_vpc" "requester" {
  filter {
    name   = "tag:Name"
    values = ["${var.requester_vpc_name}"]
  }
}

data "aws_route_table" "accepter" {
  vpc_id = "${data.aws_vpc.accepter.id}"

  filter {
    name   = "tag:Name"
    values = ["${var.accepter_route_table == "" ? "${var.accepter_vpc_name}-public" : var.accepter_route_table }"]
  }
}

data "aws_route_table" "requester" {
  vpc_id = "${data.aws_vpc.requester.id}"

  filter {
    name   = "tag:Name"
    values = ["${var.requester_route_table == "" ? "${var.requester_vpc_name}-public" : var.requester_route_table }"]
  }
}

/*
  Peering
  --
  A peering connection is established here
*/
resource "aws_vpc_peering_connection" "with_accepter" {
  peer_vpc_id = "${data.aws_vpc.accepter.id}"
  vpc_id      = "${data.aws_vpc.requester.id}"
  auto_accept = true

  accepter {
    // Allow private DNS resolution between VPCs
    allow_remote_vpc_dns_resolution = "${var.accepter_allow_dns_resolution == "yes" ? true : false }"
  }

  tags = "${var.tags}"
}

/*
  Routing
  --
  Routes are required, this way we can redirect the traffic between our VPC
  throught the correct VPC peering gateway.


  For each VPCs, member of this peering, a route must exist, to route the traffic throught
  the peering gateway to the other end of the peering.


  The monitoring VPC has "public" routing table.
  We target the VPC "public" route table, as each public subnet is already associated with it.


  Check https://docs.aws.amazon.com/AmazonVPC/latest/PeeringGuide/vpc-peering-routing.html
*/

# From Accepter network to Requester
resource "aws_route" "from_accepter_to_requester" {
  route_table_id            = "${data.aws_route_table.accepter.id}"
  destination_cidr_block    = "${data.aws_vpc.requester.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.with_accepter.id}"
}

# From Requester to Accepter
resource "aws_route" "from_requester_to_accepter" {
  route_table_id            = "${data.aws_route_table.requester.id}"
  destination_cidr_block    = "${data.aws_vpc.accepter.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.with_accepter.id}"
}
