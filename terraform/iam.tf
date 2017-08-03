resource "aws_iam_user" "travis-user" {
  name = "Travis"
}

resource "aws_iam_user_policy_attachment" "attach-travis-code-deploy" {
  user       = "${aws_iam_user.travis-user.name}"
  policy_arn = "${aws_iam_policy.travis-code-deploy.arn}"
}

resource "aws_iam_role" "code-deploy-service-role" {
  name = "CodeDeployServiceRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "ec2-service-role" {
  name = "CodeDeployEC2DeployInstance"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach-aws-code-deploy-role" {
  role       = "${aws_iam_role.code-deploy-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "attach-aws-ec2-deploy-role" {
  role       = "${aws_iam_role.ec2-service-role.name}"
  policy_arn = "${aws_iam_policy.ec2-code-deploy.arn}"
}

resource "aws_iam_policy" "ec2-code-deploy" {
  name = "CodeDeployEC2Permissions"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "travis-code-deploy" {
  name        = "TravisCodeDeployPolicy"
  path        = "/"
  description = "Enable Travis CI to access code deploy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:RegisterApplicationRevision",
        "codedeploy:GetApplicationRevision"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:application:${aws_codedeploy_app.business-days-deploy.name}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:CreateDeployment",
        "codedeploy:GetDeployment"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:GetDeploymentConfig"
      ],
      "Resource": [
        "arn:aws:codedeploy:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:deploymentconfig:CodeDeployDefault.OneAtATime",
        "arn:aws:codedeploy:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:deploymentconfig:CodeDeployDefault.HalfAtATime",
        "arn:aws:codedeploy:${var.AWS_REGION}:${data.aws_caller_identity.current.account_id}:deploymentconfig:CodeDeployDefault.AllAtOnce"
      ]
    }
  ]
}
EOF
}
