#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
project_dir=$(dirname -- "$script_dir")
template="$project_dir/maintenance/maintenance.html"
runtime_dir="$project_dir/data/maintenance"

usage() {
	echo "Usage: $0 {on|off|status} [forum|auth|n]..." >&2
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
	on|off|status)
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
			cp "$template" "$temporary_page"
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
