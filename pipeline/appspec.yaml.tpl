version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "${task_definition}"
        LoadBalancerInfo:
          ContainerName: "${container_name}"
          ContainerPort: "${container_port}"
        PlatformVersion: "LATEST"
        NetworkConfiguration:
            AwsvpcConfiguration:
              Subnets: [${subnets_a}, ${subnets_b}, ${subnets_c}]
              SecurityGroups: [${security_groups}]
              AssignPublicIp: "ENABLED"
# Hooks:
# - BeforeInstall: "BeforeInstallHookFunctionName"
# - AfterInstall: "AfterInstallHookFunctionName"
# - AfterAllowTestTraffic: "AfterAllowTestTrafficHookFunctionName"
# - BeforeAllowTraffic: "BeforeAllowTrafficHookFunctionName"
# - AfterAllowTraffic: "AfterAllowTrafficHookFunctionName"