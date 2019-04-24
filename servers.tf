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

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/${var.script_name}",
      "bash /tmp/${var.script_name}"
    ]
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("imaki_Frankfurt.pem")}"
  }
}
