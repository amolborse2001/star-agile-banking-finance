resource "aws_instance" "test-server" {
  ami                    = "ami-06b21ccaeff8cd686"  # AMI ID for the instance
  instance_type         = "t2.micro"                 # Instance type
  key_name              = "mypermanentkey"           # Name of the key pair
  vpc_security_group_ids = ["sg-047cdca1ff3d954c2", "sg-0da6313eb3762de38"]  # Security groups

  connection {
    type        = "ssh"
    user        = "ec2-user"                         # User for SSH
    private_key = file("./mypermanentkey.pem")      # Path to the private key file
    host        = self.public_ip                      # Use the public IP of the instance
  }

  provisioner "remote-exec" {
    inline = ["echo 'wait to start the instance'"]   # Command to execute after instance is up
  }

  tags = {
    Name = "test-server"                              # Tag for the instance
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"  # Store IP in inventory file
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"  # Run Ansible playbook
  }
}
