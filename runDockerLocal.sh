#!/bin/bash

if [ -f .aws-env ]; then
    source .aws-env
fi    
docker build --rm -t cantaloupe:latest . && docker run --rm -ti -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --tmpfs /tmp --tmpfs /run -v $1:/images:ro -p 8182:8182 --name image cantaloupe:latest

