provider "aws" {
  region = "us-east-1"
}

resource "aws_launch_configuration" "ubuntu" {
  image_id        = "ami-07ebfd5b3428b6f4d"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
            #!/bin/bash
            echo "Hello twink" > index.html
            nohup busybox httpd -f -p ${var.server_port} &
            EOF  

  lifecycle {
    create_before_destroy = trufe
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

resource "aws_autoscaling_group" "ubuntu" {
  launch_configuration = aws_launch_configuration.ubuntu.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform_asg_test"
    propagate_at_launch = true
  }
}


