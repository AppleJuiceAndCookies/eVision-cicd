# AWS Cluster ECS
resource "aws_ecs_cluster" "eVision_ecs_cluster" {
  name = var.eVision_ecs_cluster_name
}

resource "aws_ecs_task_definition" "eVision_task" {
  family                   = "eVision-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "eVision-task",
      "image": "${var.eVision_ecr_repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.eVision_container_port},
          "hostPort": ${var.eVision_container_port},
          "Protocol": "tcp"
        }
      ],
      "memory": ${var.eVision_memory},
      "cpu": ${var.eVision_cpu}
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.eVision_memory       # Specifying the memory our container requires
  cpu                      = var.eVision_cpu         # Specifying the CPU our container requires
  execution_role_arn       = var.IAMecsTaskExecutionRoleARN #"${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_ecs_service" "eVision_service" {
  name            = "eVision-service"
  cluster         = "${aws_ecs_cluster.eVision_ecs_cluster.id}"
  task_definition = "${aws_ecs_task_definition.eVision_task.arn}"
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers we want deployed to 3
  deployment_maximum_percent = 200

  load_balancer {
    target_group_arn = "${aws_lb_target_group.eVision_target_group.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.eVision_task.family}"
    container_port   = var.eVision_container_port # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_default_subnet.eVision_default_subnet_a.id}", "${aws_default_subnet.eVision_default_subnet_b.id}", "${aws_default_subnet.eVision_default_subnet_c.id}"]
    assign_public_ip = true # Providing our containers with public IPs (needed because of how networking works between Fargate platforms)
    security_groups  = ["${aws_security_group.eVision_service_sg.id}"] # Setting the security group
  }
}
