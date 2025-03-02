provider "aws"{
    region = "us-west-1"
} 

resource "aws_instance" "studio-server"{
    ami = "ami-094b981da55429bfc"
    instance_type = "t2.micro"
    key_name = "Jenkins_Server_Keypair"
    //security_groups = ["studio-server-sg"]
    vpc_security_group_ids = [aws_security_group.studio-server-sg.id]
    subnet_id = aws_subnet.studio-public-subnet-01.id  
}

resource "aws_security_group" "studio-server-sg"{
    name = "studio-server-sg"
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

resource "aws_vpc" "studio-vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "studio-vpc"
    }           
}

resource "aws_subnet" "studio-public-subnet-01" {    
    vpc_id = aws_vpc.studio-vpc.id
    cidr_block = "10.1.0.0/24"
    availability_zone = "us-west-1a"    
    tags = {
        Name = "studio-public-subnet-01"
    }
}

resource "aws_subnet" "studio-public-subnet-02"{
    vpc_id= aws_vpc.studio-public-subnet-02.id
    cidr_block="10.2.0.0/24"
    availability_zone="us-west-1b"
    tags = {
        Name = "studio-public-subnet-02"
    }
}

resource "aws_internet_Gateway" "studio-igw"{
    vpc = aws_vp.studio-vpc.id
    tags = {
        Name = "studio-igw"
    }
}

resource "route_table" "studio-public-route-table"{
    vpc_id = aws_vpc.studio-vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.studio-igw.id
    }
    tags = {
        Name = "studio-public-route-table"
    }   
}

resource "aws_route_table_association" "studio-public-rt-association-01"{
    subnet_id = aws_subnet.studio-public-subnet-01.id
    route_table_id = route_table.studio-public-route-table.id   
}

resource "aws_route_table_association" "studio-public-rt-association-02"{
    subnet_id = aws_subnet.studio-public-subnet-02.id
    route_table_id = route_table.studio-public-route-table.id
}
   
