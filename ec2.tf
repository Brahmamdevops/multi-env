resource "aws_instance" "web" {
  ami           = "ami-03265a0778a880afb" # devops-practice 
  instance_type = "t2.micro" 
  vpc_security_group_ids= [aws_security_group.roboshop-all.id] # this means list

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt" 
  }

  tags = {
    Name = "Helloterraform" 
  }

   connection { 
    type     = "ssh"
    user     = "centos"
    password = "DevOps321"
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo this is remote-exec",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx"
    ]
  }
  

}


resource "aws_security_group" "roboshop-all" {  #this is terraform name, for terraform reference only
  name        = "roboshop-all-aws" # this is for AWS

  ingress {
    description      = "allow all ports"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "port 80"
    from_port        = 80 
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "roboshop-all-aws"
  }
}