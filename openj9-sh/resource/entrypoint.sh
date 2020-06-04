#!/bin/sh
set -e

if [ -n "$1" ]; then
  SH_BASH=$1
  echo "启动脚本: ${SH_BASH}"
  chmod +x "${SH_BASH}"
  sh "${SH_BASH}"

  #Don`t exit!
  tail -f /dev/null
else
  echo "没有设置启动脚本"
fi

exec "$@"