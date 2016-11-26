#!/bin/bash
yum install -y aws-cli
echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
echo "ECS_ENGINE_AUTH_TYPE=dockercfg" >> /etc/ecs/ecs.config
echo "ECS_ENGINE_AUTH_DATA=`cat /home/ec2-user/.docker/config.json | jq -c '.auths'`" >> /etc/ecs/ecs.config
