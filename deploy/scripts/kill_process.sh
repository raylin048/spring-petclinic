#!/bin/bash

echo "Remove Existed Container"
docker compose -f /home/ubuntu/deploy/scripts/docker-compose.yml down || true
