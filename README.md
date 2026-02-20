# Shield 统一对外出口

[![GPL-3.0](https://img.shields.io/github/license/auto-novel/shield)](https://github.com/auto-novel/shield#license)

这是统一对外出口代理，包含一个监控本网站各项服务实时运行状态与可用性的仪表盘。

## 部署

下载项目：

```bash
> git clone https://github.com/auto-novel/shield.git
> cd shield
```

创建并编辑 `.env` 文件，内容如下:

```bash
CLOUDFLARE_API_TOKEN=           # Cloudflare 的 API token
```

运行 `docker compose up -d` 命令启动服务。
