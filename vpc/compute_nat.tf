resource "aws_instance" "NAT" {
  ami                    = "ami-00d1f8201864cc10c"
  instance_type          = "t2.micro"
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.webserver.id]
  key_name = aws_key_pair.annas.key_name
  source_dest_check = false  

  tags = {
    Name = "NAT_Instance"
  }
}