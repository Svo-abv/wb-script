#!/bin/bash
set -e

if [ -f "$(dirname "$0")/.env" ]; then
  source "$(dirname "$0")/.env";
fi

if [ -z "$TG_BOT_KEY" ]; then
  TG_BOT_KEY="$TG_BOT_KEY"
fi
if [ -z "$TG_CHAT_KEY" ]; then
  TG_CHAT_KEY="$TG_CHAT_KEY"
fi
if [ -z "$WB_API_KEY" ]; then
  WB_API_KEY="$WB_API_KEY"
fi

if [ -z "$WB_API_URL" ]; then
  WB_API_URL="$WB_API_URL"
fi


WORK_DIR=$(pwd)

function get-orders(){
  ORDERS=$(curl -s $WB_API_URL -H "Authorization: $WB_API_KEY" | jq '.orders | length')
  check-orders
}

function check-orders(){
  if [ "$ORDERS" -gt 0  ]; then
      send-tg-message
  fi
}

function send-tg-message(){ 
  curl --output /dev/null --show-error --fail  -s -X POST https://api.telegram.org/bot$TG_BOT_KEY/sendMessage -d chat_id=$TG_CHAT_KEY -d text="У вас новый заказ на WB!!!"
}

get-orders