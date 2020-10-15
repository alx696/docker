#父镜像
FROM registry.cn-shanghai.aliyuncs.com/xm69/openj9:14

#版本定义
## 注意: 清华镜像路径经常调整, 修改版本前检查链接是否可用!
ENV VERSION_KAFKA 2.6.0
ENV VERSION_ZOOKEEPER 3.5.8
ENV KAFKA_CONFIG "kafka/config/server.properties"

#工作目录
WORKDIR /server

#复制脚本
COPY ["resource/", "/resource/"]

RUN \
  mv /resource/entrypoint.sh / && \
  chmod +x /entrypoint.sh && \
  mv /resource/ssl /server/ && \
  rm -rf resource && \
  # 准备Kafka
  wget "https://mirrors.tuna.tsinghua.edu.cn/apache/kafka/$VERSION_KAFKA/kafka_2.12-$VERSION_KAFKA.tgz" && \
  tar zxf "kafka_2.12-$VERSION_KAFKA.tgz" && \
  rm "kafka_2.12-$VERSION_KAFKA.tgz" && \
  mv "kafka_2.12-$VERSION_KAFKA" "kafka" && \
  echo "" >> $KAFKA_CONFIG && \
  echo "#base" >> $KAFKA_CONFIG && \
  echo "listeners=PLAINTEXT://0.0.0.0:9092,SSL://0.0.0.0:9093" >> $KAFKA_CONFIG && \
  echo "advertised.listeners=PLAINTEXT://172.17.0.1:9092,SSL://172.17.0.1:9093" >> $KAFKA_CONFIG && \
  echo "ssl.keystore.location=/server/ssl/keystore.jks" >> $KAFKA_CONFIG && \
  echo "ssl.keystore.password=123456" >> $KAFKA_CONFIG && \
  echo "ssl.truststore.location=/server/ssl/truststore.jks" >> $KAFKA_CONFIG && \
  echo "ssl.truststore.password=123456" >> $KAFKA_CONFIG && \
  echo "ssl.client.auth=required" >> $KAFKA_CONFIG && \
  echo "" >> $KAFKA_CONFIG && \
  echo "#1 minute before period will be discarded" >> $KAFKA_CONFIG && \
  echo "offsets.retention.check.interval.ms=60000" >> $KAFKA_CONFIG && \
  echo "offsets.retention.minutes=1" >> $KAFKA_CONFIG && \
  # 准备Zookeeper
  wget "https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/stable/apache-zookeeper-$VERSION_ZOOKEEPER-bin.tar.gz" && \
  tar zxf "apache-zookeeper-$VERSION_ZOOKEEPER-bin.tar.gz" && \
  rm "apache-zookeeper-$VERSION_ZOOKEEPER-bin.tar.gz" && \
  mv "apache-zookeeper-$VERSION_ZOOKEEPER-bin" "zookeeper" && \
  mv "zookeeper/conf/zoo_sample.cfg" "zookeeper/conf/zoo.cfg" && \
  sed -i "s/tmp/server\/data/g" "zookeeper/conf/zoo.cfg" && \
  # forward log to docker log collector
  mkdir -p /server/kafka/logs/ && \
  touch /server/kafka/logs/kafkaServer.out && \
  ln -sf /dev/stdout /server/kafka/logs/kafkaServer.out

#入口
ENTRYPOINT ["/entrypoint.sh"]

#设置监听端口(主机要想访问必须通过-p设置映射)
EXPOSE 2181 9092 9093
