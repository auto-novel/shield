# Shield 统一对外出口

[![GPL-3.0](https://img.shields.io/github/license/auto-novel/shield)](https://github.com/auto-novel/shield#license)
[![cd](https://github.com/auto-novel/shield/actions/workflows/cd.yml/badge.svg)](https://github.com/auto-novel/shield/actions/workflows/cd.yml)

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

## 维护模式

`forum`、`auth` 和 `n` 的维护模式由宿主机 `data/maintenance` 目录下对应的 HTML 文件控制，无需重启或重新加载 Caddy。

```bash
./scripts/maintenance.sh on n
./scripts/maintenance.sh on forum auth
./scripts/maintenance.sh off forum auth
./scripts/maintenance.sh status
./scripts/maintenance.sh on
./scripts/maintenance.sh off
```

未指定站点时默认操作全部站点。开启后，对应站点的页面请求会返回维护页面和 HTTP 503；关闭后立即恢复反向代理。
