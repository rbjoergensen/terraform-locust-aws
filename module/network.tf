resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "locust-${var.locust_name}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "locust-${var.locust_name}"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { 
      Name = "locust-${var.locust_name}"
  }
}

resource "aws_subnet" "subnets" {
  for_each = {for subnet in var.subnets: subnet.cidr => subnet}
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.zone
  map_public_ip_on_launch = true

  tags = { 
      Name = "locust-${var.locust_name}"
  }
}

resource "aws_route_table_association" "main" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  name   = var.sg_name
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = var.ip_whitelist
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1" # All protocols
    cidr_blocks     = [ "0.0.0.0/0" ]
  }
}