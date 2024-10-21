data "amazon-ami" "ubuntu2204" {
  filters = {
    architecture        = "x86_64"
    virtualization-type = "hvm"
    root-device-type    = "ebs"
    name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  }
  owners      = ["099720109477"]
  most_recent = true
  region      = var.aws_primary_region
}

source "amazon-ebs" "vm" {
  region        = var.aws_primary_region
  ami_name      = "${var.image_name}-${var.image_version}"
  instance_type = var.aws_instance_type
  ssh_username  = "ubuntu"
  ssh_interface = "public_ip"
  communicator  = "ssh"
  source_ami    = data.amazon-ami.ubuntu2204.id

  user_data = <<-EOF
              #!/bin/bash
              sleep 30
              sudo apt-get update
              sudo apt-get install -y gnupg ca-certificates
              sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32
              sudo apt-get update
              EOF
}