# AWS Cluster ECS
resource "aws_ecs_cluster" "eVision_ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecs_task_definition" "eVision_task" {
  family                   = "${var.service_name}-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.service_name}-task",
      "image": "${var.eVision_ecr_repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.eVision_container_port},
          "hostPort": ${var.eVision_container_port},
          "Protocol": "tcp"
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512       # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = var.pipeline_role
}

resource "aws_ecs_service" "eVision_service" {
  name            = "${var.service_name}-service"
  cluster         = "${aws_ecs_cluster.eVision_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.eVision_task.arn}"
  launch_type     = "FARGATE"
  desired_count   = 2 # Setting the number of containers we want deployed to 3
  deployment_maximum_percent = 200

  load_balancer {
    target_group_arn = "${aws_alb_target_group.eVision_target_group.0.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.eVision_task.family}"
    container_port   = var.eVision_container_port # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.eVision_default_subnet_a.id}", "${aws_default_subnet.eVision_default_subnet_b.id}", "${aws_default_subnet.eVision_default_subnet_c.id}"]
    assign_public_ip = true # Providing our containers with public IPs (needed because of how networking works between Fargate platforms)
    security_groups  = ["${aws_security_group.eVision_service_sg.id}"] # Setting the security group
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  depends_on = [aws_alb_listener.eVision_listener]
}