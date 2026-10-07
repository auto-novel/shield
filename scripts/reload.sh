#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
compose_file="$project_dir/docker-compose.yml"
config=/etc/caddy/Caddyfile

compose() {
	docker compose -f "$compose_file" "$@"
}

# 先校验再重载：校验不过就直接退出，绝不把坏配置推进去。
if ! output=$(compose exec -T caddy caddy validate --config "$config" --adapter caddyfile 2>&1); then
	echo "$output" >&2
	echo "caddyfile: validate failed, not reloading" >&2
	exit 1
fi
echo "caddyfile: validate ok"

if ! output=$(compose exec -T caddy caddy reload --config "$config" --adapter caddyfile 2>&1); then
	echo "$output" >&2
	echo "caddyfile: reload failed, still serving the previous config" >&2
	exit 1
fi
echo "caddyfile: reloaded"
