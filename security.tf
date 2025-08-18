# Bastion Security Group (Public)
resource "aws_security_group" "bastion_sg" {
  name        = "towfique-bastion-sg"
  description = "Allow SSH access to Bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from anywhere (demo only)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "towfique-bastion-sg"
  }
}

# Vote/Result App Security Group (Private)
resource "aws_security_group" "vote_result_sg" {
  name        = "towfique-vote-result-sg"
  description = "Allow Vote/Result app traffic"
  vpc_id      = aws_vpc.main.id

  # App HTTP port inside VPC
  ingress {
    description = "HTTP inside VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # App port 8080 from Bastion
  ingress {
    description     = "App access from Bastion"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # SSH only from Bastion
  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "towfique-vote-result-sg"
  }
}

# Redis Worker Security Group (Private)
resource "aws_security_group" "redis_worker_sg" {
  name        = "towfique-redis-worker-sg"
  description = "Allow Redis worker traffic"
  vpc_id      = aws_vpc.main.id

  # Redis from inside VPC
  ingress {
    description = "Redis inside VPC"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # SSH only from Bastion
  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "towfique-redis-worker-sg"
  }
}

# Postgres Security Group (Private)
resource "aws_security_group" "postgres_sg" {
  name        = "towfique-postgres-sg"
  description = "Allow Postgres access from Worker and Vote/Result"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Postgres from Worker"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.redis_worker_sg.id]
  }

  ingress {
    description     = "Postgres from Vote/Result"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.vote_result_sg.id]
  }

  # ICMP (ping) from VPC
  ingress {
    description = "ICMP from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # SSH from Bastion
  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "towfique-postgres-sg"
  }
}
