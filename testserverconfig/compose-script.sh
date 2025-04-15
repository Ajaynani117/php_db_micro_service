
#!/usr/bin/env bash

sudo DOCKER_IMAGE=$1 docker-compose -f /home/ec2-user/testserverconfig/docker-compose.yml up -d