#########################################
# Instance A - Vote + Result (Private)
#########################################
resource "aws_instance" "instance_a" {
  ami                         = "ami-020cba7c55df1f615" # Ubuntu 22.04 LTS
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.vote_result_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "towfique-instance-a"
    Role = "vote-result"
  }
}

#########################################
# Instance B - Redis + Worker (Private)
#########################################
resource "aws_instance" "instance_b" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.redis_worker_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "towfique-instance-b"
    Role = "redis-worker"
  }
}

#########################################
# Instance C - PostgreSQL (Private)
#########################################
resource "aws_instance" "instance_c" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.postgres_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "towfique-instance-c"
    Role = "postgres"
  }
}

#########################################
# Bastion Host (Public)
#########################################
resource "aws_instance" "bastion" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "towfique-bastion"
    Role = "bastion"
  }
}
