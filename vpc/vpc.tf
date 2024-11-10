resource "aws_vpc" "apci_main_vpc" {
  cidr_block = var.vpc_cidr_block

    tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-vpc"
  })
}

# CREATING INTERNET GATEWAY--------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.apci_main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}


# CREATING FRONTEND SUBNETS------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "frontend_subnet_az_1a" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.frontend_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet-az-1a"
  })
}

resource "aws_subnet" "frontend_subnet_az_1b" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.frontend_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet-az-1b"
  })
}


# CREATING BACKEND SUBNETS-------------------------------------------------------------------------------------------------------------------------
resource "aws_subnet" "backend_subnet_az_1a" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[0]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-az-1a"
  })
}

resource "aws_subnet" "backend_subnet_az_1b" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[1]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-az-1b"
  })
}


# CREATING DATABSE SUBNEST-----------------------------------------------------------------------------------------------------------
resource "aws_subnet" "db_subnet_az_1a" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[2]
  availability_zone = var.availability_zone[0]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az-1a"
  })
}

resource "aws_subnet" "db_subnet_az_1b" {
  vpc_id     = aws_vpc.apci_main_vpc.id
  cidr_block = var.backend_cidr_block[3]
  availability_zone = var.availability_zone[1]

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-az-1b"
  })
}

# CREATING PUBLIC ROUTE TABLE-------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.apci_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}


# CREATING ROUTE TABLE ASSOCIATION FOR FRONTEND SUBNETS-----------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "frontend_subnet_az_1a" {
  subnet_id      = aws_subnet.frontend_subnet_az_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "frontend_subnet_az_1b" {
  subnet_id      = aws_subnet.frontend_subnet_az_1b.id
  route_table_id = aws_route_table.public_rt.id
}



# CREATING AN ELASTIC IP FOR NAT GATEWAY--------------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "eip" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip"
  })
}

# CREATING A NAT GATEWAY---------------------------------------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.frontend_subnet_az_1a.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip, aws_subnet.frontend_subnet_az_1a]
}

# CREATING A PRIVATE ROUTE TABLE FOR AVAILABILITY ZONE 1A-----------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "private_rt_az1a" {
  vpc_id = aws_vpc.apci_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az1a"
  })
}

# CREATING ROUTE TABLE ASSOCIATION FOR BACKEND SUBNETS---------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "backend_subnet_az_1a" {
  subnet_id      = aws_subnet.backend_subnet_az_1a.id
  route_table_id = aws_route_table.private_rt_az1a.id
}

resource "aws_route_table_association" "db_subnet_az_1a" {
  subnet_id      = aws_subnet.db_subnet_az_1a.id
  route_table_id = aws_route_table.private_rt_az1a.id
}


# CREATING AN EIP FOR AVAILABILITY ZONE 1B----------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "eip_az1b" {
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-az1b"
  })
}

# CREATING A NAT GATEWAY FOR AZ 1B------------------------------------------------------------------------------------------------------------------------------------
resource "aws_nat_gateway" "nat_gw_az1b" {
  allocation_id = aws_eip.eip_az1b.id
  subnet_id     = aws_subnet.frontend_subnet_az_1b.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-az1b"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip_az1b, aws_subnet.frontend_subnet_az_1b]
}


# CREATING A PRIVATE ROUTE TABLE FOR AVAILABILITY ZONE1B-----------------------------------------------------------------------------------------------------------------------
resource "aws_route_table" "private_rt_az1b" {
  vpc_id = aws_vpc.apci_main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_az1b.id
  }

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-az1b"
  })
}


# CREATING ROUTE TABLE ASSOCIATION FOR BACKEND SUBNETS IN AZ 1B---------------------------------------------------------------------------------------------------------------
resource "aws_route_table_association" "backend_subnet_az_1b" {
  subnet_id      = aws_subnet.backend_subnet_az_1b.id
  route_table_id = aws_route_table.private_rt_az1b.id
}

resource "aws_route_table_association" "db_subnet_az_1b" {
  subnet_id      = aws_subnet.db_subnet_az_1b.id
  route_table_id = aws_route_table.private_rt_az1b.id
}
