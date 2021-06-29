provider "aws"{
    region = "ap-south-1"
    profile = "default"
}
resource "aws_instance" "TF_task" {
  ami           = "ami-0ad704c126371a549"
  instance_type = "t2.micro"
  
  key_name = "Ayush"
  security_groups = ["ayush"]
  tags = {
    Name = "TF-task"
  }
}
resource "null_resource" "Resource_Items" {
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:/Users/hp/Downloads/Ayush.pem")
        host = aws_instance.TF_task.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install httpd -y",
            "sudo systemctl start httpd",
        ]
    }
}
