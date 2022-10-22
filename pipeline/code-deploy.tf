resource "aws_codedeploy_app" "eVision_codedeploy_app" {
  compute_platform = "ECS"
  name             = "${var.service_name}-service-deploy"
}

resource "aws_codedeploy_deployment_group" "eVision_codedeploy_deployment_group" {
  app_name               = "${aws_codedeploy_app.eVision_codedeploy_app.name}"
  deployment_group_name  = "${var.service_name}-service-deploy-group"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = "${var.pipeline_role}"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = "${aws_ecs_cluster.eVision_ecs_cluster.name}"
    service_name = "${aws_ecs_service.eVision_service.name}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${aws_alb_listener.eVision_listener.arn}"]
      }

      target_group {
        name = "${aws_alb_target_group.eVision_target_group.*.name[0]}"
        # name = "${aws_alb_target_group.eVision_tg_blue.name}"
        
      }

      target_group {
        name = "${aws_alb_target_group.eVision_target_group.*.name[1]}"
        # name = "${aws_alb_target_group.eVision_tg_green.name}"
      }
    }
  }
}

# resource "aws_s3_object" "appspec_object" {
#   bucket = var.artifacts_bucket_name
#   key    = "appspec.yaml"
#   acl    = "private"
#   content = templatefile("${path.module}/appspec.yaml.tpl", {
#     task_definition = "${aws_ecs_task_definition.eVision_task.arn}"
#     container_name  = "${aws_ecs_task_definition.eVision_task.family}"
#     container_port  = "${var.eVision_container_port}"
#     subnets_a       = "${aws_default_subnet.eVision_default_subnet_a.id}"
#     subnets_b       = "${aws_default_subnet.eVision_default_subnet_b.id}"
#     subnets_c       = "${aws_default_subnet.eVision_default_subnet_c.id}"
#     security_groups = "${aws_security_group.eVision_service_sg.id}"
#   })

#   depends_on = [aws_s3_bucket_versioning.s3_artifacts_bucket_versioning]

#   tags = {
#     UseWithCodeDeploy = true
#   }
# }

# resource "aws_s3_object" "taskdef_object" {
#   bucket = var.artifacts_bucket_name
#   key    = "taskdef.json"
#   acl    = "private"
#   content = templatefile("${path.module}/taskdef.json.tpl", {
#     name      = "${var.service_name}-task"
#     image     = "${var.eVision_ecr_repository_url}"
#     port      = "${var.eVision_container_port}"
#     role_arn  = "${var.pipeline_role}"
#   })

#   depends_on = [aws_s3_bucket_versioning.s3_artifacts_bucket_versioning]

#   tags = {
#     UseWithCodeDeploy = true
#   }
# }