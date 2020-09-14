resource "aws_vpc" "infra" {
  cidr_block = "172.31.0.0/24"

  tags = {
    name = "infra_vpc"
  }
}

resource "aws_subnet" "infra_subnet"{
  vpc_id = aws_vpc.infra.id
  cidr_block = "172.31.0.0/25"
}

resource "aws_security_group" "infra_sg"{
  name = "ssh"
  description = "For ssh Access"
  vpc_id = aws_vpc.infra.id

  ingress {
    description = "SSH from outside"
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 22
    to_port = 22
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]    
  }
    ingress {
    description = "Fo"
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]    
  }
}

resource "aws_instance" "ansible_jenkins" {
  ami = "ami-023e0c35fc414e78b"
  count = 1
  instance_type = "t2.micro"
  key_name = "ssh_ci"
  vpc_security_group_ids = [aws_security_group.infra_sg.id]
  subnet_id = aws_subnet.infra_subnet.id
  associate_public_ip_address = true 
  tags = {
    Name = "ansible_control"
  }
  
  provisioner "remote-exec" {
     inline = [
        "sudo yum install java-1.8*",
        "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
        "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key"
     ]
     connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("./ssh_ci.pem")
        host = self.public_ip 
  }
  }
}

resource "aws_instance" "ansible_worker" {
  ami = "ami-023e0c35fc414e78b"
  count = 1
  instance_type = "t2.micro"
  key_name = "ssh_ci"
  associate_public_ip_address = true
  subnet_id = aws_subnet.infra_subnet.id
  vpc_security_group_ids = [aws_security_group.infra_sg.id]
  

  tags = {
    Name = "ansible_worker-${count.index}"
  }
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.infra.id

  tags = {
    Name = "custom_igw"
  }
}

resource "aws_route_table" "custome_route_igw" {
  vpc_id = aws_vpc.infra.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }

  tags = {
    Name = "custom_route"
  }
}

resource "aws_route_table_association" "custom_route_association" {
  subnet_id = aws_subnet.infra_subnet.id
  route_table_id = aws_route_table.custome_route_igw.id
}
