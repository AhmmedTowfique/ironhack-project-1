#########################################
# Instance A1 - Vote + Result (Private, AZ1)
#########################################
resource "aws_instance" "instance_a1" {
  ami                         = "ami-020cba7c55df1f615" # Ubuntu 22.04 LTS
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_a.id # Private subnet in AZ1
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.vote_result_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 5000:5000 my-vote-image
              docker run -d -p 5001:5001 my-result-image
              EOF

  tags = {
    Name = "towfique-instance-a1"
    Role = "vote-result"
  }
}

#########################################
# Instance A2 - Vote + Result (Private, AZ2)
#########################################
resource "aws_instance" "instance_a2" {
  ami                         = "ami-020cba7c55df1f615" # Ubuntu 22.04 LTS
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_b.id # Private subnet in AZ2
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.vote_result_sg.id]
  associate_public_ip_address = false

  user_data = <<-EOF
              #!/bin/bash
              docker run -d -p 5000:5000 my-vote-image
              docker run -d -p 5001:5001 my-result-image
              EOF

  tags = {
    Name = "towfique-instance-a2"
    Role = "vote-result"
  }
}

#########################################
# Instance B - Redis + Worker (Private, AZ1)
#########################################
resource "aws_instance" "instance_b" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_bc.id # Private subnet for B & C
  key_name                    = "2fik-key"
  vpc_security_group_ids      = [aws_security_group.redis_worker_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "towfique-instance-b"
    Role = "redis-worker"
  }
}

#########################################
# Instance C - PostgreSQL (Private, AZ1)
#########################################
resource "aws_instance" "instance_c" {
  ami                         = "ami-020cba7c55df1f615"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_bc.id # Private subnet for B & C
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
