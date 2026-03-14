resource "aws_security_group" "web_sg" {
    name = "${var.project_name}-sg"
    description = "Permitir HTTP"
    vpc_id = data.aws_vpc.default.id

    ingress {
        description = "HTTP desde Internet"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Salida libre"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-sg"
    }

}

resource "aws_instance" "web" {
    ami = data.aws_ssm_parameter.al2023_ami.value
    instance_type = var.instance_type
    subnet_id = data.aws_subnets.default.ids[0]
    vpc_security_group_ids = [aws_security_group.web_sg.id]
    associate_public_ip_address = true
    user_data = file("${path.module}/user_data.sh")

    tags = {
        Name = "${var.project_name}-ec2"
    }

}