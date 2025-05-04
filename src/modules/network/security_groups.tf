resource "aws_security_group" "rds_security_group" {
  name = "rds-security-group"
  description = "Security group for RDS"
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "rds-security-group"
    }
  )
}

resource "aws_security_group_rule" "sg_rds_ingress_traffic" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  cidr_blocks = aws_subnet.network_public[*].cidr_block
  security_group_id = aws_security_group.rds_security_group.id
}

resource "aws_security_group_rule" "sg_rds_egress_traffic" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds_security_group.id
}
