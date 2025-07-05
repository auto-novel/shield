# Status

[![GPL-3.0](https://img.shields.io/github/license/auto-novel/status)](https://github.com/auto-novel/status#license)

这是专用于监控本网站各项服务实时运行状态与可用性的仪表盘。

## 部署

下载项目：

```bash
> git clone https://github.com/auto-novel/status.git
> cd status
```

创建并编辑 `.env` 文件，内容如下:

```bash
CLOUDFLARE_API_TOKEN=           # Cloudflare 的 API token
```

运行 `docker compose up -d` 命令启动服务。
