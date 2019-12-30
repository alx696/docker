#!/bin/sh
set -e

#启动Java Application
APP_START="/app/start.sh"
if [ -f ${APP_START} ]
then
  chmod +x "${APP_START}"
  sh "${APP_START}"
  #备注:start.sh中必须使用绝对路径!
else
  echo "没有启动脚本: ${APP_START}"
fi

#Don`t exit!
tail -f /dev/null

exec "$@"