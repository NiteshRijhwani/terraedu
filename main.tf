provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "test_instance" {
  ami = "ami-0283a57753b18025b"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test_instance_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello Nitesh" > index.xhtml
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true  

  tags = {
    "Name" = "tf-example-ec2"
  }

}

resource "aws_security_group" "test_instance_sg" {
  name = "tf-example-sg"

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}