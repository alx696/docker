#!/bin/sh
set -e

# 如未设置报错
if [ -z "$IP" ]; then
  echo "没有设置IP!"
  exit 1
fi

# 根据端口配置设置监听
LISTENERS="PLAINTEXT:\/\/0.0.0.0:9092"
ADVERTISED_LISTENERS="PLAINTEXT:\/\/localhost:9092"
if [ ! -z "$PLAINTEXT_PORT" ]; then
  ADVERTISED_LISTENERS="PLAINTEXT:\/\/${IP}:${PLAINTEXT_PORT}"
fi

if [ ! -z "$SSL_PORT" ]; then
  LISTENERS="${LISTENERS},SSL:\/\/0.0.0.0:9093"
  ADVERTISED_LISTENERS="${ADVERTISED_LISTENERS},SSL:\/\/${IP}:${SSL_PORT}"
fi

# 如未设置给默认值
if [ -z "$KEYSTORE_PASSWORD" ]; then
  KEYSTORE_PASSWORD="123456"
fi

# 替换
KAFKA_CONFIG="/server/kafka/config/server.properties"
sed -i "s/listeners=.*/listeners=${LISTENERS}/g" ${KAFKA_CONFIG}
sed -i "s/advertised.listeners=.*/advertised.listeners=${ADVERTISED_LISTENERS}/g" ${KAFKA_CONFIG}
sed -i "s/ssl.keystore.password=.*/ssl.keystore.password=${KEYSTORE_PASSWORD}/g" ${KAFKA_CONFIG}

# 服务异常关闭后,如果不清理此目录,会因为broker.id重复而造成kafka无法启动.
rm -rf /server/data/zookeeper
# 服务异常关闭后,如果不清理此目录,会因为meta.properties中的clusterId不匹配而造成kafka无法启动.
rm -rf /tmp/kafka-logs

/server/zookeeper/bin/zkServer.sh start-foreground &
/server/kafka/bin/kafka-server-start.sh -daemon ${KAFKA_CONFIG}

#Don`t exit!
tail -f /dev/null
