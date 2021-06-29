provider "aws"  {                                      #Provider
    region = "ap-south-1"
    profile = "default"
}
resource "aws_db_instance" "db1" {                     #RDS DB Instance
    allocated_storage    = 10
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t2.micro"
    name                 = "mydb"
    username             = "root"
    password             = "redhat123"
    parameter_group_name = "default.mysql5.7"
    publicly_accessible  = true
    skip_final_snapshot  = true
}
resource "aws_instance" "ins1" {                       #EC2 Instance
    ami = "ami-010aff33ed5991201"
    instance_type="t2.micro"
    security_groups = [ "ayush" ]
    key_name = "Ayush"
    tags={
    Name="wp"
    }
}

resource "null_resource" "Resource_Items" {            #configuring apache server and wordpress
    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("C:/Users/hp/Desktop/TF Tasks/task-3/Ayush.pem")
        host = aws_instance.ins1.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "sudo yum install docker -y",
            "sudo yum install httpd -y",
            "sudo systemctl start httpd",
            "sudo systemctl start docker",
            "sudo docker pull wordpress",
            "sudo docker run --name wp -p 8080:80 -d wordpress"
        ]
    }
}

output "IP" {
    value = "IP : ${aws_instance.ins1.public_ip}"
}

output "Endpoint"  {
value = "Endpoint : ${aws_db_instance.db1.endpoint}"
}

output "Username" {
value = "Username : ${aws_db_instance.db1.username}"
}

output "Port" {
value = "Port : ${aws_db_instance.db1.port}"
}

output "DB_Identifier" {
value = "Database Identifier : ${aws_db_instance.db1.name}"
}
