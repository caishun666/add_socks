#!/bin/bash

# 转换文件格式以确保使用 Unix 换行符
sed -i 's/\r$//' /root/add_socks.sh

# 安装 jq
apt-get install jq -y

CONFIG_FILE="/usr/local/etc/xray/config.json"
SOCKS_ENTRY='{
  "port": 20000,
  "protocol": "socks",
  "settings": {
    "auth": "password",
    "accounts": [
      {
        "user": "admin",
        "pass": "admin"
      }
    ],
    "udp": true
  }
}'

# 使用 jq 插入新的 SOCKS 入站规则
jq --argjson newEntry "$SOCKS_ENTRY" '.inbounds += [$newEntry]' "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

# 重启 Xray 服务
systemctl restart xray

echo "SOCKS 入站规则已添加到 $CONFIG_FILE，Xray 已重启"
