# Local variable for key name
locals {
  key_name = "moleculer-app-key"
}

# Key-Pair
resource "aws_key_pair" "Molecular-instances-key" {
  key_name   = local.key_name
  public_key = file("~/.ssh/id_rsa.pub")
}

# Security Group for Api Instance
resource "aws_security_group" "api_instance_sg" {
  name        = "api_instance_security_group"
  description = "Allows HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_instance.service1_instance.private_ip, aws_instance.service2_instance.private_ip, aws_instance.nats_instance.private_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# Api Instance
resource "aws_instance" "api_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = local.key_name
  vpc_security_group_ids = aws_security_group.api_instance_sg.id
  subnet_id              = aws_subnet.public_subnet[0].id
  user_data              = <<EOF
#!/bin/bash

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g moleculer
sudo npm install moleculer
sudo npm install moleculer-web
sudo npm install moleculer-nats-transporter
EOF

  tags = {
    Name = "api_instance"
  }
}

# Security Group for Service#1 Instance
resource "aws_security_group" "service_1_instance_sg" {
  name        = "service_1_instance_security_group"
  description = "Allows HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_instance.api_instance.private_ip, aws_instance.service2_instance.private_ip, aws_instance.nats_instance.private_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Service#1 Instance
resource "aws_instance" "service_1_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = local.key_name
  vpc_security_group_ids = aws_security_group.service_1_instance_sg.id
  subnet_id              = aws_subnet.private_subnet[0].id
  user_data              = <<EOF
#!/bin/bash

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g moleculer
sudo npm install moleculer
sudo npm install moleculer-web
sudo npm install moleculer-nats-transporter
EOF

  tags = {
    Name = "service_1_instance"
  }
}

# Security Group for Service#2 Instance
resource "aws_security_group" "service_2_instance_sg" {
  name        = "service_2_instance_security_group"
  description = "Allows HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_instance.service1_instance.private_ip, aws_instance.api_instance.private_ip, aws_instance.nats_instance.private_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Service#2 Instance
resource "aws_instance" "service_2_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = local.key_name
  vpc_security_group_ids = aws_security_group.service_2_instance_sg.id
  subnet_id              = aws_subnet.private_subnet[0].id
  user_data              = <<EOF
#!/bin/bash

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g moleculer
sudo npm install moleculer
sudo npm install moleculer-web
sudo npm install moleculer-nats-transporter
EOF

  tags = {
    Name = "service_2_instance"
  }
}

# Security Group for Nats Instance
resource "aws_security_group" "nats_instance_sg" {
  name        = "nats_instance_security_group"
  description = "Allows HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_instance.service1_instance.private_ip, aws_instance.service2_instance.private_ip, aws_instance.api_instance.private_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Nats Instance
resource "aws_instance" "nats_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = local.key_name
  vpc_security_group_ids = aws_security_group.nats_instance_sg.id
  subnet_id              = aws_subnet.private_subnet[1].id
  user_data              = <<EOF
#!/bin/bash

curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g nats-server

sudo nats-server &
EOF

  tags = {
    Name = "nats_instance"
  }
}
