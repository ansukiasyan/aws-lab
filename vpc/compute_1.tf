resource "aws_instance" "webserver" {
  ami                    = "ami-0f7919c33c90f5b58"
  instance_type          = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.webserver.id]
  key_name = aws_key_pair.annas.key_name  

  tags = {
    Name = "WebServer"
  }
}

resource "aws_security_group" "webserver" {
  name = "WebDMZ"
  vpc_id = aws_vpc.test.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "annas" {
  key_name   = "annas"
  public_key = var.ssh_key
}