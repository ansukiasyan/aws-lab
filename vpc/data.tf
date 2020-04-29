data "aws_security_group" "default" {
    vpc_id = aws_vpc.test.id 
    name = "default"
}
