provider "aws"{
    region = "us-west-1"
} 

resource "aws_instance" "demo-server"{
    ami = "ami-094b981da55429bfc"
    instance_type = "t2.micro"
    key_name = "Jenkins_Server_Keypair"
    security_groups = ["demo-server-sg"]
}

resource "aws_security_group" "demo-server-sg"{
    name = "demo-server-sg"
    ingress{
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    tags = {
        Name = "ssh-ports"
    }
}