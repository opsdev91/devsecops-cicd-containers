resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id = "subnet-02c87c853e4e8bc24"
  key_name = aws_key_pair.ec2.id
  associate_public_ip_address = true
  provisioner "remote-exec" {
    on_failure = fail
    connection {
      user = "ubuntu"
      private_key = file("${path.module}/../.ssh/id_rsa")
      host = "${self.public_ip}"
    }

    inline = [
      "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE=644 sh -",
      "sudo apt update -y",
      "kubectl create namespace argocd",
      "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
    ]
  }
}

resource "aws_key_pair" "ec2" {
  key_name   = "ec2"
  public_key = file("${path.module}/../.ssh/id_rsa.pub")
}

resource "aws_security_group" "sg" {
  vpc_id = "vpc-038139570a16495c7"
  name = "allow_ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["115.78.100.150/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
