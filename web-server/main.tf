provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ubuntu" {
  ami                    = "ami-07ebfd5b3428b6f4d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello, World" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF

  tags = {
    Name = "ubuntu_vm"
  }
}


resource "aws_security_group" "instance" {
  name = "ubuntu_instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
