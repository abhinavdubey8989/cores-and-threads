
provider "aws" {
  region = "ap-south-1"
}

# EC2 with 2 cores
resource "aws_instance" "example" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.large"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname java-2-core
    echo "java-2-core" > /etc/hostname
    sed -i "1s/^/127.0.0.1 java-2-core\\n/" /etc/hosts
  EOF

  tags = {
    Name = "java-2-core"
  }
}


# EC2 with 4 cores
resource "aws_instance" "example" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.xlarge"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname java-4-core
    echo "java-4-core" > /etc/hostname
    sed -i "1s/^/127.0.0.1 java-4-core\\n/" /etc/hosts
  EOF

  tags = {
    Name = "java-4-core"
  }
}


# EC2 with 8 cores
resource "aws_instance" "example" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "m5.2xlarge"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname java-8-core
    echo "java-8-core" > /etc/hostname
    sed -i "1s/^/127.0.0.1 java-8-core\\n/" /etc/hosts
  EOF

  tags = {
    Name = "java-8-core"
  }
}
