#!/bin/sh

SSL_CRT=/etc/ssl-key/$DOMAIN.crt
SSL_KEY=/etc/ssl-key/$DOMAIN.key

mkdir -p /etc/ssl-key

echo "注册email"
acme.sh --register-account -m email=$EMAIL
echo "生成证书"
acme.sh --issue -d $DOMAIN --standalone -k ec-256
echo "安装证书"
acme.sh --installcert -d $DOMAIN --fullchainpath $SSL_CRT --keypath $SSL_KEY --ecc

cat>/etc/xray/config.json<<EOF
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 443,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "flow": "xtls-rprx-direct",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ],
                "decryption": "none",
                "fallbacks": [                   
					{
                        "path": "$WSPATH",
                        "dest": 1234,
                        "xver": 1
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp",
                "security": "xtls",
                "xtlsSettings": {
                    "alpn": [
                        "http/1.1"
                    ],
                    "certificates": [
                        {
                            "certificateFile": "$SSL_CRT",
                            "keyFile": "$SSL_KEY"
                        }
                    ]
                }
            }
        },
 		{
            "port": 1234,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "$UUID",
                        "level": 0,
                        "email": "love@example.com"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "acceptProxyProtocol": true,
                    "path": "$WSPATH"
                }
            }
        }   
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF

/usr/bin/xray -config /etc/xray/config.json