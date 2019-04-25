resource "aws_instance" "jenkins-master" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  monitoring = "false"
  vpc_security_group_ids = ["sg-05a1228141f3a88cf"]
  root_block_device = {
    volume_size = "10"
    volume_type = "gp2"
  }
  tags { Name = "jenkins-master" }

  provisioner "file" {
    source = "${var.script_name}"
    destination = "/tmp/${var.script_name}"
  }
  provisioner "file" {
    source = "~/.ssh/${var.key_name}.pem"
    destination = "~/.ssh/clients.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.script_name}",
      "bash /tmp/${var.script_name}",
      "chmod 400 ~/.ssh/clients.pem"
    ]
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/imaki_Frankfurt.pem")}"
  }
}

# ================== CLIENTS ==================== #
resource "aws_instance" "jenkins-client" {
  count = 2 # number of clients
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  monitoring      = "false"
  vpc_security_group_ids = ["sg-0bab7953543f29ecc"]
  root_block_device = {
    volume_size = "8"
    volume_type = "gp2"
  }

  tags {
    Name = "jenkins-client-${count.index + 1}"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo apt-get update -y",
      "sleep 10",
      "sudo apt-get install -y openjdk-8-jre"
    ]
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("~/.ssh/imaki_Frankfurt.pem")}"
  }
}
