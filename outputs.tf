output "peering_id" {
  value       = "${aws_vpc_peering_connection.with_accepter.id}"
  description = "The peering connection id"
}

output "accepter_vpc_id" {
  value       = "${data.aws_vpc.accepter.id}"
  description = "Accepter VPC id"
}

output "accepter_vpc_cidr_block" {
  value       = "${data.aws_vpc.accepter.cidr_block}"
  description = "Accepter VPC cidr block"
}

output "requester_vpc_id" {
  value       = "${data.aws_vpc.requester.id}"
  description = "Requester VPC id"
}

output "requester_vpc_cidr_block" {
  value       = "${data.aws_vpc.requester.cidr_block}"
  description = "Requester VPC cidr block"
}
