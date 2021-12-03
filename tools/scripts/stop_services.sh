#!/bin/bash

docker-compose -f docker/prometheus/docker-compose.yml down
docker-compose -f docker/grafana/docker-compose.yml down
docker-compose -f docker/rocket-chat/docker-compose.yml down
