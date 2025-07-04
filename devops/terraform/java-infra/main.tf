
provider "aws" {
  region = "ap-south-1"
}

# EC2 with 2 cores
resource "aws_instance" "java-1" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.large"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname java-1
    echo "java-1" > /etc/hostname
    sed -i "1s/^/127.0.0.1 java-1\\n/" /etc/hosts
  EOF

  tags = {
    Name = "java-1"
  }
}


# EC2 with 4 cores
resource "aws_instance" "java-2" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.xlarge"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname java-2
    echo "java-2" > /etc/hostname
    sed -i "1s/^/127.0.0.1 java-2\\n/" /etc/hosts
  EOF

  tags = {
    Name = "java-2"
  }
}


# EC2 with 8 cores
resource "aws_instance" "java-3" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.2xlarge"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname java-3
    echo "java-3" > /etc/hostname
    sed -i "1s/^/127.0.0.1 java-3\\n/" /etc/hosts
  EOF

  tags = {
    Name = "java-3"
  }
}