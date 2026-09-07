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
