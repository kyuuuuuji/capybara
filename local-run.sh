#!/bin/bash

# write your slack token 
export HUBOT_SLACK_TOKEN=
export PORT=8080
export CAPYBARA_CHANNEL_ID=C44845W21

# redis://<host>:<port>[/<brain_prefix>]
# export REDIS_URL=redis://localhost:6379/capybara

npm install

./bin/hubot --adapter \slack
