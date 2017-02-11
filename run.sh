#!/bin/bash

# write your slack token 
export HUBOT_SLACK_TOKEN=
export PORT=8080
export CAPYBARA_CHANNEL_ID=

# redis://<host>:<port>[/<brain_prefix>]
# export REDIS_URL=redis://localhost:6379/capybara

npm install

forever start -c coffee node_modules/.bin/hubot --adapter \slack