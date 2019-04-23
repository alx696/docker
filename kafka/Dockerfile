#父镜像
FROM xm69/openjdk:alpine-13.0

#版本定义
ENV VERSION_KAFKA 2.2.0
ENV VERSION_ZOOKEEPER 3.4.14

#工作目录
WORKDIR /server

#复制脚本
COPY ["resource/", "/resource/"]

RUN \
  apk update && \
  apk add --no-cache bash && \
  mv /resource/entrypoint.sh / && \
  chmod +x /entrypoint.sh && \
  # 初始配置
  touch /server/server.conf && \
  echo "IP=127.0.0.1" >> /server/server.conf && \
  echo "PORT=9092" >> /server/server.conf && \
  # 准备Kafka
  curl -O "http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/$VERSION_KAFKA/kafka_2.12-$VERSION_KAFKA.tgz" && \
  tar zxf "kafka_2.12-$VERSION_KAFKA.tgz" && \
  mv "kafka_2.12-$VERSION_KAFKA" "kafka" && \
  sed -i "s/\#listeners\=/listeners\=/g" "kafka/config/server.properties" && \
  sed -i "s/\/\/\:9092/\/\/0.0.0.0\:9092/g" "kafka/config/server.properties" && \
  sed -i "s/\#advertised.listeners\=/advertised.listeners\=/g" "kafka/config/server.properties" && \
  sed -i "s/your.host.name\:9092/localhost\:9092/g" "kafka/config/server.properties" && \
  echo " " "kafka/config/server.properties" && \
  echo "#older than 1 minute period will be discarded" "kafka/config/server.properties" && \
  echo "offsets.retention.check.interval.ms=60000" "kafka/config/server.properties" && \
  echo "offsets.retention.minutes=1" "kafka/config/server.properties" && \
  # 准备Zookeeper
  curl -O "https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-$VERSION_ZOOKEEPER/zookeeper-$VERSION_ZOOKEEPER.tar.gz" && \
  tar zxf "zookeeper-$VERSION_ZOOKEEPER.tar.gz" && \
  mv "zookeeper-$VERSION_ZOOKEEPER" "zookeeper" && \
  mv "zookeeper/conf/zoo_sample.cfg" "zookeeper/conf/zoo.cfg"

#入口
ENTRYPOINT ["/entrypoint.sh"]

#设置监听端口(主机要想访问必须通过-p设置映射)
EXPOSE 2181 9092
