# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Default VPC Subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer (ALB)
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids
}

# Target Group for ALB with Health Check
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/index.html"   # Ensure this path is accessible
    interval            = 35              # Increased time between health checks
    timeout             = 15              # Increased timeout to handle slower responses
    healthy_threshold   = 2
    unhealthy_threshold = 5               # Allows time for instance to initialize fully
  }
}

# Listener for ALB
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Launch Template for Auto Scaling Group
resource "aws_launch_template" "example_lt" {
  name_prefix   = "example-launch-template"
  image_id      = "ami-0e86e20dae9224db8" # Replace with Ubuntu AMI ID
  instance_type = "t2.micro"              # Free-tier eligible

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2
    systemctl start apache2
    systemctl enable apache2
    echo "Hello from $(hostname)" > /var/www/html/index.html
    EOF
  )
}

# Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "example_asg" {
  desired_capacity     = 3
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.example_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "example-asg-instance"
    propagate_at_launch = true
  }
}
