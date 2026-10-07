# Shield 统一对外出口

[![GPL-3.0](https://img.shields.io/github/license/auto-novel/shield)](https://github.com/auto-novel/shield#license)

提供统一对外出口代理，并包含监控各项服务实时运行状态与可用性的仪表盘。

## 部署

```bash
# 1. 克隆仓库
git clone https://github.com/auto-novel/shield.git
cd shield

# 2. 生成环境变量配置
cat > .env << EOF
CLOUDFLARE_API_TOKEN=<cloudflare_api_token>
EOF

# 3. 启动服务
docker compose up -d
```

## 重载 Caddyfile

`caddy/` 目录以只读方式挂载到容器内 `/etc/caddy`，改完配置后执行：

```bash
./scripts/reload.sh
```

脚本会先校验再重载：校验不通过就直接退出、不会重载；重载失败时 Caddy 会保留正在运行的旧配置并报错，不会中断线上。

## 维护模式

`forum`、`auth` 和 `n` 的维护模式由宿主机 `srv/maintenance` 目录下对应的 HTML 文件控制，无需重启或重新加载 Caddy。

```bash
./scripts/maintenance.sh on 30min n
./scripts/maintenance.sh on 2h forum auth
./scripts/maintenance.sh on 2h
./scripts/maintenance.sh off forum auth
./scripts/maintenance.sh status
./scripts/maintenance.sh off
```

维护时长支持小时（如 `2h`）和分钟（如 `30min`）；开启时未指定站点则默认操作全部站点。开启后，对应站点的页面请求会显示预计剩余时间、以 `UTC+08:00` 表示的预计恢复时间和 HTTP 503，并每 60 秒自动刷新；关闭后立即恢复反向代理。
