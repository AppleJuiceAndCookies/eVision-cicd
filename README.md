# eVision-cicd
CI/CD solution for eVision project

The solution consists of two parts: build and deploy.


In the first part, we use terraform to create CI/CD roles, group policies and projects in CodeBuild.

## Build
For run root-part do:
0. go to the root dir: cd root
1. terraform init
2. terraform verify
3. terraform plan
4. terraform apply

For run user-part do:
0. go to the user dir: cd user
1. terraform init
2. terraform verify
3. terraform plan
4. terraform apply

Sources:
https://registry.terraform.io/

## Deploy
