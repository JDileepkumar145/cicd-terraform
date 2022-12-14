resource "aws_security_group" "apache" {
  name        = "clint"
  description = "allow endsuer"
  vpc_id      = aws_vpc.dev-vpc1.id

  ingress {
    description     = "admin"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastian.id]
  }

  ingress {
    description     = "Enduser"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  tags = {
    Name = "stage-apache"
  }
}


resource "aws_instance" "apache" {
  ami                    = "ami-0b89f7b3f054b957e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.privates[0].id
  vpc_security_group_ids = [aws_security_group.apache.id]
  tags = {
    Name = "apache-app"
  }
}


resource "aws_instance" "grafana" {
  ami                    = "ami-0b89f7b3f054b957e"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.privates[1].id
  vpc_security_group_ids = [aws_security_group.apache.id]
  tags = {
    Name = "stage-grafana"
  }
}