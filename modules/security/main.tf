resource "aws_security_group" "alb" {
    name        = "${var.project}-alb-sg"
    description = "Security group for ALB(allow http from the internet)"
    vpc_id      = var.vpc_id
    
    ingress {
        description = "HTTP from Internet"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0     
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
tags = {
    Name = "${var.project}-alb-sg"
    }
}


resource "aws_security_group" "web" {
    name        = "${var.project}-web-sg"
    description = "Security group for web servers (allow http from ALB)"
    vpc_id      = var.vpc_id
    
    ingress {
        description = "HTTP from ALB"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.alb.id]
}
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0     
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "${var.project}-web-sg"
    }
}



resource "aws_security_group" "db" {
    name        = "${var.project}-db-sg"
    description = "allow postgresql from web servers tier only "
    vpc_id      = var.vpc_id
    
    ingress {
        description = "postgresql from web servers"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        security_groups = [aws_security_group.web.id]
}
    egress {
        description = "Allow all outbound traffic"
        from_port   = 0     
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
  
}
tags = {
    Name = "${var.project}-db-sg"
    }
}