#!/usr/bin/env bash

# Script for controlling redis.
# Usage: `redis.sh {up|down} app_name`

set -e

redis-up() {
  mkdir -p /tmp/redis

  app_name=$1
  config_file=${2:-/usr/local/etc/redis.conf}

  echo "Redis: starting ${app_name} with ${config_file}"

  redis-server ${config_file} --port 0 --unixsocket $socket_file --daemonize yes
}

redis-down() {
  if [ ! -e $socket_file ]; then
    echo "Redis: ${app_name} is already shut downed"
    exit 0
  fi
  echo "Redis: shuting down ${app_name}"
  redis-cli -s ${socket_file} shutdown
  rm -rf ${socket_file}
}

if (( $# != 2 )); then
  echo "Usage: redis.sh {up|down} app_name"
  exit 1
fi

app_name=$2
socket_file="/tmp/redis/${app_name}.socket"
log_file="/tmp/redis/${app_name}.log"

case "$1" in
  "up") redis-up $2 ;;
  "down") redis-down $2 ;;
esac