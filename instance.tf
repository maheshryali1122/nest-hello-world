resource "aws_security_group" "sg_for_nestjs" {
    name        = "sgfornestjs"
    vpc_id      = aws_vpc.myvpc.id
    ingress {
        protocol        = "tcp"
        from_port       = 22
        to_port         = 22
        cidr_blocks = ["0.0.0.0/0"]
    }


    ingress {
        protocol        = "tcp"
        from_port       = 3000
        to_port         = 3000
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


}

resource "aws_instance" "nestjs" {
  ami = "ami-0cf2b4e024cdb6960"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  availability_zone = "us-west-2a"
  key_name = "nestkeypair"
  subnet_id = aws_subnet.subnets[0].id
  security_groups = [ aws_security_group.sg_for_nestjs.id  ]
  tags = {
    Name = "nestjsproject"
  }
}
resource "null_resource" "nullr" {
    provisioner "remote-exec" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./id_rsa") 
    host        = aws_instance.nestjs.public_ip
  }

  inline = [
    "git clone https://github.com/maheshryali1122/nest-hello-world.git",
    "sudo apt update",
    "sudo apt install -y nodejs npm",
    "cd nest-hello-world",
    "npm install",
    "npm run start &"
  ]
}
  
}

