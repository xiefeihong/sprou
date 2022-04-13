# Docker Fly

### 本地测试

docker build repo for xray

https://hub.docker.com/r/v2fly/v2fly-core

docker build -t xray-docker .
docker run -d -p 443:443 --env-file .env xray-docker

### 步骤

 1. Fork 本专案到自己的 GitHub 账户（用户名以 `example` 为例）
 2. 修改专案名称，注意不要包含 `Xray` 和 `heroku` 两个关键字（修改后的专案名以 `demo` 为例）
 3. 修改 `README.md`，将 `xiefeihong/Xray-heroku` 替换为自己的内容（如 `example/demo`）

> [![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https://github.com/xiefeihong/sprou2)

 4. 回到专案首页，点击上面的链接以部署 Xray