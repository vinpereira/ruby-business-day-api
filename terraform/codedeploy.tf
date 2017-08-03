resource "aws_codedeploy_app" "business-days-deploy" {
  name = "BusinessDaysCodeDeploy"
}

resource "aws_codedeploy_deployment_group" "business-days-travis-deploy-group" {
  app_name               = "${aws_codedeploy_app.business-days-deploy.name}"
  deployment_group_name  = "TravisDeploy"
  service_role_arn       = "${aws_iam_role.code-deploy-service-role.arn}"
  deployment_config_name = "CodeDeployDefault.OneAtATime"

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "Business Days"
  }
}
