#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
template="$project_dir/maintenance/maintenance.html"
runtime_dir="$project_dir/data/maintenance"

usage() {
	echo "Usage: $0 on {<number>h|<number>min} [forum|auth|n]..." >&2
	echo "       $0 {off|status} [forum|auth|n]..." >&2
	exit 2
}

expand_services() {
	for service in "$@"; do
		case "$service" in
			forum|auth|n)
				echo "$service"
				;;
			*)
				echo "Unknown service: $service" >&2
				return 1
				;;
		esac
	done
}

action="${1:-}"
case "$action" in
	on)
		[ "$#" -ge 2 ] || usage
		duration=$2
		shift 2
		case "$duration" in
			*min)
				duration_value=${duration%min}
				duration_multiplier=60
				duration_label="$duration_value 分钟"
				;;
			*h)
				duration_value=${duration%h}
				duration_multiplier=3600
				duration_label="$duration_value 小时"
				;;
			*)
				echo "Invalid duration: $duration" >&2
				usage
				;;
		esac
		case "$duration_value" in
			""|0|0*|*[!0-9]*)
				echo "Invalid duration: $duration" >&2
				usage
				;;
		esac
		duration_seconds=$((duration_value * duration_multiplier))
		maintenance_end_epoch=$(($(date +%s) + duration_seconds))
		maintenance_end=$(TZ=Asia/Shanghai date -d "@$maintenance_end_epoch" "+%Y-%m-%d %H:%M UTC+08:00")
		maintenance_end_iso=$(TZ=Asia/Shanghai date -d "@$maintenance_end_epoch" "+%Y-%m-%dT%H:%M:%S%:z")
		;;
	off|status)
		shift
		;;
	*)
		usage
		;;
esac

if [ "$#" -eq 0 ]; then
	set -- forum auth n
fi
services=$(expand_services "$@") || usage

case "$action" in
	on)
		mkdir -p "$runtime_dir"
		for service in $services; do
			active_page="$runtime_dir/$service.html"
			temporary_page="$runtime_dir/.$service.html.$$"
			sed \
				-e "s|{{MAINTENANCE_DURATION}}|$duration_label|g" \
				-e "s|{{MAINTENANCE_END}}|$maintenance_end|g" \
				-e "s|{{MAINTENANCE_END_ISO}}|$maintenance_end_iso|g" \
				"$template" >"$temporary_page"
			chmod 0644 "$temporary_page"
			mv "$temporary_page" "$active_page"
			echo "$service maintenance: on"
		done
		;;
	off)
		for service in $services; do
			rm -f "$runtime_dir/$service.html"
			echo "$service maintenance: off"
		done
		;;
	status)
		for service in $services; do
			if [ -f "$runtime_dir/$service.html" ]; then
				echo "$service maintenance: on"
			else
				echo "$service maintenance: off"
			fi
		done
		;;
esac
