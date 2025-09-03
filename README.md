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
TENCENTCLOUD_SECRET_ID=     # 你的腾讯云SecretId
TENCENTCLOUD_SECRET_KEY=    # 你的腾讯云SecretKey
DOMAINS=       # 你的域名列表，用英文逗号分隔，例：*.example.com,example.com
EMAIL=         # 你的邮箱地址，例：tebayaki@example.com
DRY_RUN=       # 如果第一次运行，可指定True进行测试，留空则正式申请证书
CRON_SCHEDULE= # 执行更新证书任务的crontab表达式
TZ=Asia/Shanghai
PUID=1000
PGID=1000
```
`compose.yaml`
```yaml
services:
  certbot-dns-tencentcloud:
    image: tebayaki/certbot-dns-tencentcloud:latest
    container_name: certbot-dns-tencentcloud
    restart: unless-stopped
    environment:
      - TENCENTCLOUD_SECRET_ID=${TENCENTCLOUD_SECRET_ID}
      - TENCENTCLOUD_SECRET_KEY=${TENCENTCLOUD_SECRET_KEY}
      - REGION=${REGION}
      - DOMAINS=${DOMAINS}
      - EMAIL=${EMAIL}
      - DRY_RUN=${DRY_RUN}
      - CRON_SCHEDULE=${CRON_SCHEDULE} # renew every 10 days if not set
      - TZ=${TZ:-Asia/Shanghai}
      - PUID=${PUID:-1000}
      - PGID=${PGID:-1000}
    volumes:
      - ${HOME}/letsencrypt:/data
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