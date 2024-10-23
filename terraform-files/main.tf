resource "aws_instance" "test-server" {
  ami                    = "ami-06b21ccaeff8cd686"
  instance_type         = "t2.micro"
  key_name              = "mypermanentkey"
  vpc_security_group_ids = ["sg-047cdca1ff3d954c2"]  # Use the selected security group ID

  connection {
    type        = "ssh"
    user       = "ec2-user"
    private_key = file("./mypermanentkey.pem")
    host       = self.public_ip
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start the instance'"]
  }

  tags = {
    Name = "test-server"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
  }
}
