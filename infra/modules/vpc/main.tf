resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env_name}-vpc"
    Env  = var.env_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env_name}-igw"
    Env  = var.env_name
  }
}

# --- Subredes públicas (índices 0 y 1 → x.0.0/24, x.1.0/24) ---
resource "aws_subnet" "public" {
  for_each = { a = 0, b = 1 }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = var.azs[each.key == "a" ? 0 : 1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-public-${each.key}"
    Env  = var.env_name
    Tier = "public"
  }
}

# --- Subredes privadas-app (índices 10 y 11) ---
resource "aws_subnet" "private_app" {
  for_each = { a = 10, b = 11 }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = var.azs[each.key == "a" ? 0 : 1]

  tags = {
    Name = "${var.env_name}-private-app-${each.key}"
    Env  = var.env_name
    Tier = "private-app"
  }
}

# --- Subredes privadas-db (índices 20 y 21) ---
resource "aws_subnet" "private_db" {
  for_each = { a = 20, b = 21 }

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = var.azs[each.key == "a" ? 0 : 1]

  tags = {
    Name = "${var.env_name}-private-db-${each.key}"
    Env  = var.env_name
    Tier = "private-db"
  }
}

# --- Route table pública: 0.0.0.0/0 -> IGW ---
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = "${var.env_name}-rt-public", Env = var.env_name }
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# --- Route tables privadas: sin ruta a Internet todavía (se añade al crear el NAT) ---
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.env_name}-rt-private-app", Env = var.env_name }
}

resource "aws_route_table_association" "private_app" {
  for_each       = aws_subnet.private_app
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.env_name}-rt-private-db", Env = var.env_name }
}

resource "aws_route_table_association" "private_db" {
  for_each       = aws_subnet.private_db
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_db.id
}