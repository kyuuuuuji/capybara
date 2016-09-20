#!/bin/bash

# write your slack token 
export HUBOT_SLACK_TOKEN=
export PORT=8080

npm install

./bin/hubot --adapter \slack
