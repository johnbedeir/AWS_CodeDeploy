resource "aws_codedeploy_app" "my_codedeploy_app" {
  name = "MyCodeDeployApp"
}


resource "aws_codedeploy_deployment_group" "my_codedeploy_deployment_group" {
  app_name              = aws_codedeploy_app.my_codedeploy_app.name
  deployment_group_name = "MyDeploymentGroup"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "CodeDeployEC2"
    }
  }

  load_balancer_info {
    elb_info {
      name = aws_elb.web_lb.name
    }
  }
}

