#!/bin/sh
set -e

#Start
KAFKA_CONFIG="/server/kafka/config/server.properties"

# 替换IP和端口
sed -i "s/advertised.listeners=PLAINTEXT\:\/\/.*/advertised.listeners=PLAINTEXT\:\/\/${KAFKA_HOST}/g" "${KAFKA_CONFIG}"

# 服务异常关闭后,如果不清理此目录,会因为broker.id重复而造成kafka无法启动.
rm -rf /server/data/zookeeper
# 服务异常关闭后,如果不清理此目录,会因为meta.properties中的clusterId不匹配而造成kafka无法启动.
rm -rf /tmp/kafka-logs

/server/zookeeper/bin/zkServer.sh start-foreground &
/server/kafka/bin/kafka-server-start.sh -daemon "${KAFKA_CONFIG}"

#Don`t exit!
tail -f /dev/null

exec "$@"
