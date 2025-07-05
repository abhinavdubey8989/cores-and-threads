
provider "aws" {
  region = "ap-south-1"
}

# EC2 with 2 cores & 8 GB RAM
resource "aws_instance" "cores-2" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.large"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname cores-2
    echo "cores-2" > /etc/hostname
    sed -i "1s/^/127.0.0.1 cores-2\\n/" /etc/hosts
  EOF

  tags = {
    Name = "cores-2"
  }
}


# EC2 with 4 cores & 16 GB RAM
resource "aws_instance" "cores-4" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.xlarge"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname cores-4
    echo "cores-4" > /etc/hostname
    sed -i "1s/^/127.0.0.1 cores-4\\n/" /etc/hosts
  EOF

  tags = {
    Name = "cores-4"
  }
}


# EC2 with 8 cores & 32 GB RAM
resource "aws_instance" "cores-8" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.2xlarge"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname cores-8
    echo "cores-8" > /etc/hostname
    sed -i "1s/^/127.0.0.1 cores-8\\n/" /etc/hosts
  EOF

  tags = {
    Name = "cores-8"
  }
}