data "aws_ami" "2023" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-*-x86_64"]
  }
}


resource "aws_launch_template" "web" {
  name_prefix   = "${var.project}-web-"
  image_id      = data.aws_ami.2023.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.web.name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              dnf install -y nginx
              cat > /usr/share/nginx/html/index.html <<HTML
              <h1>${var.project} running on $(hostname)</h1>
              <p> Database:${var.db_endpoint}</p>
              <p> assets bucket:${var.s3_bucket}</p>
              HTML
              systemctl enable --now nginx 
              EOF
            )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project}-web"
    }
  }
  
}



resource "aws_alb" "web" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project}-alb"
  }
  
}

resource "aws_alb_target_group" "web" {
  name     = "${var.project}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher = "200"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web.arn
  }
  
}



resource "aws_autoscaling_group" "web" {
    name                 = "${var.project}-web-asg"
  desired_capacity     = var.min_size
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.private_subnet_ids
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
  target_group_arns    = [aws_alb_target_group.web.arn]
  health_check_type    = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.project}-web"
    propagate_at_launch = true
  }
  
}


resource "aws_autoscaling_policy" "cpu_scale_up" {
  name                   = "${var.project}-cpu-scale-up"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type = "TargetTrackingScaling"

    target_tracking_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.cpu_target
    }
  
}