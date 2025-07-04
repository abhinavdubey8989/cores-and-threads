
provider "aws" {
  region = "ap-south-1"
}

# Monitoring node
resource "aws_instance" "monitoring-node" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.medium"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname monitoring-node
    echo "monitoring-node" > /etc/hostname
    sed -i "1s/^/127.0.0.1 monitoring-node\\n/" /etc/hosts
  EOF

  tags = {
    Name = "monitoring-node"
  }
}
