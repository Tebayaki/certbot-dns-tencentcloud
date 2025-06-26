# certbot-dns-tencentcloud
Certbot的腾讯云DNS-01验证自动化脚本
### 容器部署
拉取镜像
```bash
docker pull tebayaki/certbot-dns-tencentcloud:latest
```
创建项目文件夹，环境变量文件和compose文件
```
mkdir certbot-dns-tencentcloud
cd certbot-dns-tencentcloud
touch .env compose.yaml
```
`.env`
```bash
SECRET_ID=     # 你的腾讯云SecretId
SECRET_KEY=    # 你的腾讯云SecretKey
DOMAINS=       # 你的域名列表，用英文逗号分隔，例：*.example.com,example.com
EMAIL=         # 你的邮箱地址，例：tebayaki@example.com
DRY_RUN=       # 如果第一次运行，可指定True进行测试，留空则正式申请证书
```
`compose.yaml`
```yaml
services:
  certbot-dns-tencentcloud:
    image: tebayaki/certbot-dns-tencentcloud:latest
    container_name: certbot-dns-tencentcloud
    restart: unless-stopped
    environment:
      - SECRET_ID=${SECRET_ID}
      - SECRET_KEY=${SECRET_KEY}
      - DOMAINS=${DOMAINS}
      - EMAIL=${EMAIL}
      - DRY_RUN=${DRY_RUN}
      - PGID=${PGID:-1000}
      - PUID=${PUID:-1000}
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt # persistent storage for certificates
      - /var/log/letsencrypt:/var/log/letsencrypt # persistent storage for logs
```
启动容器
```bash
docker compose up -d
```
查询日志观察运行状态
```bash
docker logs certbot-dns-tencentcloud
```
### 注意事项
- 容器启动时立即尝试申请证书，第一次运行可指定环境变量`DRY_RUN`为`True`进行测试
- 默认每10天尝试1次续约，可指定环境变量`CRON_SCHEDULE`为cron表达式以自定义行为
- 以上配置将证书和密钥保存在宿主机的`/etc/letsencrypt/live/ztoco.top/fullchain.pem`和`/etc/letsencrypt/live/ztoco.top/privkey.pem`中
- 如果其他搭载了Web服务的容器需要使用证书，需挂载`/etc/letsencrypt/`。由于上面两个路径是符号链接，挂载到`/etc/letsencrypt/live/ztoco.top/`会报错不存在该文件
