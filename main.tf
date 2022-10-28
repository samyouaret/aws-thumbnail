variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# create role for lambda
resource "aws_iam_role" "lambda_role" {

  name = "Spacelift_Test_Lambda_Function_Role"

  assume_role_policy = <<EOF
{

 "Version": "2012-10-17",

 "Statement": [

   {

     "Action": "sts:AssumeRole",

     "Principal": {

       "Service": "lambda.amazonaws.com"

     },

     "Effect": "Allow",

     "Sid": ""

   }

 ]

}

EOF

}
resource "aws_iam_policy" "iam_policy_for_lambda" {

  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

resource "aws_lambda_function" "lambda_generator" {
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  function_name    = "test_th_gen"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs16.x"
}

resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.lambda_generator.function_name
  authorization_type = "NONE"
}
