#!/bin/sh
set -e

#Start
KAFKA_CONFIG="/server/kafka/config/server.properties"

# 替换IP和端口
sed -i "s/advertised.listeners=PLAINTEXT\:\/\/.*/advertised.listeners=PLAINTEXT\:\/\/${IP}\:${PORT}/g" "${KAFKA_CONFIG}"

# 服务异常关闭后,如果不清理此目录会因为broker.id重复而造成kafka无法启动.
rm -rf /tmp/zookeeper
/server/zookeeper/bin/zkServer.sh start
/server/kafka/bin/kafka-server-start.sh -daemon "${KAFKA_CONFIG}"

#Don`t exit!
tail -f /dev/null

exec "$@"
