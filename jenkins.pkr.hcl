packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_access_key" {
  type    = string
  default = "${env("AWS_ACCESS_KEY_ID")}"
}

variable "aws_secret_key" {
  type    = string
  default = "${env("AWS_SECRET_ACCESS_KEY")}"
}

source "amazon-ebs" "jenkins" {
  access_key    = "${var.aws_access_key}"
  secret_key    = "${var.aws_secret_key}"
  ssh_username  = "ec2-user"
  ami_name      = "jenkins-server_{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-ebs"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
}

build {
  name = "aws-amazon-linux"
  sources = [
    "source.amazon-ebs.jenkins"
  ]

  provisioner "shell" {
    inline = [
      "sudo yum install -y git",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo chkconfig docker on",
      "sudo chmod a+rw /var/run/docker.sock",
      "sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod a+x /usr/local/bin/docker-compose",
      "sudo amazon-linux-extras install ansible2 -y",
      "sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo",
      "sudo yum -y install terraform"
    ]
  }
}
