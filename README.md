# Heroku Xray

### 本地测试

```
cat>.env<<EOF
EMAIL=user@foxmail.com
DOMAIN=appname.herokuapp.com
PORT=443
UUID=ce7ea10b-5b27-49ab-a93d-6b184df9cce9
WSPATH=/websocket
EOF
docker build -t xray-docker .
docker run -d -p 443:443 -p 80:80 --env-file .env xray-docker
firewall-cmd --add-port=443/tcp --permanent
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
```

### Heroku部署

 1. Fork 本专案到自己的 GitHub 账户（用户名以 `example` 为例）
 2. 修改专案名称，注意不要包含 `Xray` 和 `heroku` 两个关键字（修改后的专案名以 `demo` 为例）
 3. 修改 `README.md`，将 `xiefeihong/Xray-heroku` 替换为自己的内容（如 `example/demo`）

> [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https://github.com/xiefeihong/sprou2)

 4. 回到专案首页，点击上面的链接以部署 Xray
 
### 客户端

```json
"outbounds": [
        {
            "protocol": "vless",
            "settings": {
                "vnext": [
                    {
                        "address": "***.herokuapp.com", // heroku app URL 或者 cloudflare worker url/ip
                        "port": 443,
                        "users": [
                            {
                                "id": "", // 填写你的 UUID
                                "encryption": "none"
                            }
                        ]
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "***.herokuapp.com" // heroku app host 或者 cloudflare worker host
                },
                "wsSettings": {
                    "path": "/websocket"
                }
              }
          }
    ]
```