# aws-thumbnail

## Exporting AWS credentials

export TF_VAR_aws_secret_key=AWS_SECRET_KEY TF_VAR_aws_access_key=AWS_ACCESS_KEY

## Packing lambda in a zip file

    zip lambda_function.zip index.js node_modules yarn.lock package.json  -r

## working with terraform

    terraform apply

    terraform plan
