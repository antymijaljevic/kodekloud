# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key
# resource "tls_private_key" "key_pair" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

resource "aws_key_pair" "citadel-key" {
  key_name   = "citadel"
  public_key = file("/root/terraform-challenges/project-citadel/.ssh/ec2-connect-key.pub")
}

resource "aws_instance" "citadel" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.citadel-key.key_name
  user_data = "${file("install-nginx.sh")}"
}

resource "aws_eip" "citadel" {
  instance = aws_instance.citadel.id
  domain   = "vpc"

  provisioner "local-exec" {
    command = "echo ${self.public_dns} > /root/citadel_public_dns.txt"
  }
}