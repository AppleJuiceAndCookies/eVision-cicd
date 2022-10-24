locals {
  target_groups = ["primary", "secondary"]
  # hosts_name = ["*.amazonaws.com"]
}

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

# resource "aws_alb_target_group" "eVision_tg_green" {
#   name        = "${var.service_name}-tg-green"
#   port        = var.eVision_container_port
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "${aws_default_vpc.eVision_default_vpc.id}"
#   health_check {
#     matcher = "200-299"
#     path = "/success"
#   }
# }

# resource "aws_alb_target_group" "eVision_tg_blue" {
resource "aws_alb_target_group" "eVision_target_group" {
  # name        = "${var.service_name}-tg-blue"
  count = "${length(local.target_groups)}"
  name  = "${var.service_name}-tg-${element(local.target_groups, count.index)}"

  port        = var.eVision_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_default_vpc.eVision_default_vpc.id}"
  health_check {
    matcher = "200-299"
    path = "/success"
  }
}

resource "aws_alb_listener" "eVision_listener" {
  load_balancer_arn = "${aws_alb.eVision_alb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    # target_group_arn = "${aws_alb_target_group.eVision_tg_blue.arn}"
    target_group_arn = "${aws_alb_target_group.eVision_target_group.0.arn}"
  }
}

resource "aws_alb_listener_rule" "eVision_alb_listener_rule" {
  count        = 2
  listener_arn = "${aws_alb_listener.eVision_listener.arn}"
  priority = 50

  action {
    type             = "forward"
    # target_group_arn = "${aws_alb_target_group.eVision_tg_green.arn}"
    target_group_arn = "${aws_alb_target_group.eVision_target_group.*.arn[count.index]}"
  }

  condition {
     host_header {
      values = ["*.amazonaws.com"]
    }
  }
}