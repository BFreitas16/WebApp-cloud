#!/bin/bash

sudo docker-compose -f docker/rocket-chat/docker-compose.yml up -d --build
sudo docker-compose -f docker/grafana/docker-compose.yml up -d --build
sudo docker-compose -f docker/prometheus/docker-compose.yml up -d --build
