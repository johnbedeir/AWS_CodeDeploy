resource "aws_codedeploy_app" "my_codedeploy_app" {
  name = "MyCodeDeployApp"
}


resource "aws_codedeploy_deployment_group" "my_codedeploy_deployment_group" {
  app_name              = aws_codedeploy_app.my_codedeploy_app.name
  deployment_group_name = "MyDeploymentGroup"
  service_role_arn      = aws_iam_role.codedeploy_role.arn

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "CodeDeployEC2"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

