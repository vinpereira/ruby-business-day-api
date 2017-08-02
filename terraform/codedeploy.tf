resource "aws_codedeploy_app" "business-days-deploy" {
  name = "BusinessDaysCodeDeploy"
}

resource "aws_codedeploy_deployment_config" "business-days-travis-deploy-config" {
  deployment_config_name = "business-days-travis-deploy-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 2
  }
}

resource "aws_codedeploy_deployment_group" "business-days-travis-deploy-group" {
  app_name               = "${aws_codedeploy_app.business-days-deploy.name}"
  deployment_group_name  = "TravisDeploy"
  service_role_arn       = "${aws_iam_role.code-deploy-service-role.arn}"
  deployment_config_name = "${aws_codedeploy_deployment_config.business-days-travis-deploy-config.id}"

  ec2_tag_filter {
    key   = "api"
    type  = "KEY_AND_VALUE"
    value = "business-days"
  }
}
