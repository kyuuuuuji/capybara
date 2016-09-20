#!/bin/bash

# write your slack token 
export HUBOT_SLACK_TOKEN=
export PORT=8080

npm install

forever start -c coffee node_modules/.bin/hubot --adapter \slack