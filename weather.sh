#!/bin/bash

if [ -f .env ]; then
  source .env
fi

key="${PUSH_KEY}"
weather_key="${WEATHER_KEY}"

# 定义天气接口URL
weather_api_url="https://devapi.qweather.com/v7/weather/now?location=101020100&key=${weather_key}"

# 使用curl命令获取天气JSON数据并保存到weather.json文件
#curl -s "$weather_api_url"
weather_data=$(curl -L -X GET --compressed "$weather_api_url")

echo "$weather_data"

# 定义函数来提取JSON字段的值
get_json_value() {
    echo "$1" | grep -o "\"$2\":\"[^\"]*\"" | cut -d ":" -f 2 | sed 's/"//g'
}

# 提取所需的天气信息并存储在相应的变量中
obsTime=$(get_json_value "$weather_data" obsTime)
temp=$(get_json_value "$weather_data" temp)
feelsLike=$(get_json_value "$weather_data" feelsLike)
text=$(get_json_value "$weather_data" text)
windDir=$(get_json_value "$weather_data" windDir)
windSpeed=$(get_json_value "$weather_data" windSpeed)
humidity=$(get_json_value "$weather_data" humidity)

# 打印提取的天气信息
text="实时天气：$text, 温度：${temp}°C, 体感：${feelsLike}°C, 湿度：${humidity}%, 风向：$windDir, 风速：${windSpeed}km/h"
# 将字符串进行URL编码
text=$(printf "%s" "$text" | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g')

url="https://api2.pushdeer.com/message/push?pushkey=${key}&text=${text}"
echo $url
curl -X GET "$url"
