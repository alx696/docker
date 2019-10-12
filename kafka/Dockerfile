#父镜像
FROM xm69/openjdk:13

#版本定义
ENV VERSION_KAFKA 2.3.0
ENV VERSION_ZOOKEEPER 3.5.5

#工作目录
WORKDIR /server

#复制脚本
COPY ["resource/", "/resource/"]

RUN \
  mv /resource/entrypoint.sh / && \
  chmod +x /entrypoint.sh && \
  # 准备Kafka
  wget "https://mirrors.tuna.tsinghua.edu.cn/apache/kafka/$VERSION_KAFKA/kafka_2.12-$VERSION_KAFKA.tgz" && \
  tar zxf "kafka_2.12-$VERSION_KAFKA.tgz" && \
  rm "kafka_2.12-$VERSION_KAFKA.tgz" && \
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
  wget "https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-$VERSION_ZOOKEEPER/apache-zookeeper-$VERSION_ZOOKEEPER-bin.tar.gz" && \
  tar zxf "apache-zookeeper-$VERSION_ZOOKEEPER-bin.tar.gz" && \
  rm "apache-zookeeper-$VERSION_ZOOKEEPER-bin.tar.gz" && \
  mv "apache-zookeeper-$VERSION_ZOOKEEPER-bin" "zookeeper" && \
  mv "zookeeper/conf/zoo_sample.cfg" "zookeeper/conf/zoo.cfg" && \
  sed -i "s/tmp/server\/data/g" "zookeeper/conf/zoo.cfg" && \
  # forward log to docker log collector
  mkdir -p /server/kafka/logs/ && \
  touch /server/kafka/logs/server.log && \
  ln -sf /dev/stdout /server/kafka/logs/server.log

#入口
ENTRYPOINT ["/entrypoint.sh"]

#设置监听端口(主机要想访问必须通过-p设置映射)
EXPOSE 2181 9092
