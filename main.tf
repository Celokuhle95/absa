terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

#database instance
resource "aws_db_instance" "rds-db" {
  identifier          = "mysqlinstance"
  allocated_storage   = "10"
  engine              = "mysql"
  engine_version      = "5.7.21"
  instance_class      = "db.t2.small"
  name                = "mydb"
  username            = "celo"
  password            = "!paszword1"
  publicly_accessible = true
  skip_final_snapshot = true
}

resource "aws_s3_bucket" "default" {
  bucket = "mybooks.application.artefact"
}

resource "aws_s3_bucket_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "target/book-orders.jar"
  source = "target/book-orders.jar"
}

resource "aws_elastic_beanstalk_application" "ebs-app" {
  depends_on  = [aws_db_instance.rds-db]
  name        = "mybooksapp"
  description = "beanstalk environment to deploy java apps without worrying about the infrastructure"

  appversion_lifecycle {
    service_role          = "arn:aws:iam::573601384075:role/arn-role"
    max_count             = 128
    delete_source_from_s3 = false
    #    service_role =  aws_iam_role.beanstalk_service.arn
  }
}

resource "aws_elastic_beanstalk_application_version" "ebs-app-ver" {
  depends_on  = [aws_elastic_beanstalk_application.ebs-app]
  application = "${aws_elastic_beanstalk_application.ebs-app.name}"
  name        = "v1"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_bucket_object.default.id
}

resource "aws_elastic_beanstalk_environment" "ebs-env" {

  depends_on          = [aws_elastic_beanstalk_application_version.ebs-app-ver]
  name                = "mybooksapp-dev"
  application         = "${aws_elastic_beanstalk_application.ebs-app.name}"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.11.12 running Java 8"
  cname_prefix        = "mybooksapp-dev"
  version_label       = "${aws_elastic_beanstalk_application_version.ebs-app-ver.name}"

  #Error 502 thrown if this not set since SpringBoot app use port 8080 by default
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SERVER_PORT"
    value     = "5000"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }


}

resource "aws_iam_policy" "policy" {
  name = "aws_deploy_policy"
  path = "/"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "iam:CreateInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:PassRole",
          "iam:DeleteInstanceProfile"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  } )
}


#
#resource "aws_iam_instance_profile" "my_instance_profile" {
#  name = "my_instance_profile"
#  role = aws_iam_role.role.name
#}
#
#resource "aws_iam_role" "role" {
#  name = "test_role"
#  path = "/"
#
#  assume_role_policy = <<EOF
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Action": "sts:AssumeRole",
#            "Principal": {
#               "Service": "ec2.amazonaws.com"
#            },
#            "Effect": "Allow",
#            "Sid": ""
#        }
#    ]
#}
#EOF
#}

