resource "aws_instance" "dbserver" {
  ami                    = "ami-0f7919c33c90f5b58"
  instance_type          = "t2.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [data.aws_security_group.default.id]
  key_name = aws_key_pair.annas.key_name  

  tags = {
    Name = "DBServer"
  }
}

