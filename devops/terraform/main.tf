
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0f918f7e67a3323f0"
  instance_type = "t2.micro"
  key_name      = "ad89"
  subnet_id     = "subnet-099a16f190bac13df"

  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname my-awesome-ec2
    echo "my-awesome-ec2" > /etc/hostname
    sed -i "1s/^/127.0.0.1 my-awesome-ec2\\n/" /etc/hosts
  EOF

  tags = {
    Name = "Terraform-EC2-v2"
  }
}
