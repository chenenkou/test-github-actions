#!/bin/bash

# 设置目标时区为东八区（中国标准时间）
# export TZ="Asia/Shanghai"

if [ -f .env ]; then
  source .env
fi

key="${PUSH_KEY}"

current_time=$(date +"%Y-%m-%d %H:%M:%S")

text="现在时间 $current_time"
text="${text// /%20}"
echo $text

url="https://api2.pushdeer.com/message/push?pushkey=${key}&text=${text}"
echo $url
curl -X GET "$url"
