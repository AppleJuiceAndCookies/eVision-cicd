resource "aws_alb" "eVision_alb" {
  name               = "eVision-lb-tf" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ # Referencing the default subnets
    "${aws_default_subnet.eVision_default_subnet_a.id}",
    "${aws_default_subnet.eVision_default_subnet_b.id}",
    "${aws_default_subnet.eVision_default_subnet_c.id}"
  ]
  # Referencing the security group
  security_groups = ["${aws_security_group.eVision_lb_sg.id}"]
}

resource "aws_lb_target_group" "eVision_target_group" {
  name        = "eVision-target-group"
  port        = var.eVision_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.eVision_default_vpc.id}" # Referencing the default VPC
  health_check {
    matcher = "200-299"
    path = "/success"
  }
}

resource "aws_lb_listener" "eVision_listener" {
  load_balancer_arn = "${aws_alb.eVision_alb.arn}" # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.eVision_target_group.arn}" # Referencing our tagrte group
  }
}