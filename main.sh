#!/bin/bash

key="${PUSH_KEY}"

current_time=$(date +"%Y年%m月%d日 %H:%M:%S")  

text="现在时间 $current_time"
text="${text// /%20}"

url="https://api2.pushdeer.com/message/push?pushkey=${key}&text=${text}"

echo $url

curl -X GET "$url"
