# eVision-cicd
CI/CD solutions for eVision project


Source code: https://github.com/AppleJuiceAndCookies/eVision-docker


## First solution consists of two parts: build and deploy.


FYI

We have to separate our terraforming tasks into root and user scenarios because you can have a strict security policy and your build/deploy user should not have rights to change IAM policies and roles. You can combine them together if you like.

### Build


In the first part, we use terraform to create CI/CD roles, group policies and projects in CodeBuild.


For run root-part do:
0. go to the root dir: cd build/root
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply

For run user-part do:
0. go to the user dir: cd build/user
1. terraform init
2. terraform validate
3. terraform plan
4. terraform apply


### Deploy


In this part, we use terraform to create security roles, group policy, application load balancer, Elastic Container Service (ECS) cluster with tasks and service.


For run root-part do:
0. go to the root dir: cd deploy/root
1. terraform init
2. terraform plan
3. terraform apply

For run user-part do:
0. go to the user dir: cd deploy/user
1. terraform init
2. terraform plan
3. terraform apply


## Second solution with AWS CodePipeline

Include Source + CodeBuild + CodeDeploy

1. go to the root dir: cd pipeline-iam
2. terraform apply
3. go to the user dir: cd ../pipeline
4. terraform apply

Sources:
https://registry.terraform.io/
