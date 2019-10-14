# 环境变量

* `IP` 设置ip
*  `PORT` 设置端口

> Kafka工作时必须有确定的ip和端口，故运行容器时必须通过环境变量进行设置.

# 运行示例

```
$ docker run -d --restart=always \
  -p 50020:9092 \
  -e "KAFKA_HOST=172.17.0.1:50020" \
  --name "kafka" xm69/kafka:2.3
```

# 构建

```
$ docker build -t xm69/kafka:2.3 .
```

# 镜像制作要点

> Dockfile已经自动下载kafka和zookeeper软件包, 无需人工下载和配置.

1. 下载kafka和zookeeper并解压到resource/中,解压后文件夹应去除版本号；

2. 修改app/kafka/config/server.properties中对应项修改为下面这样:
```
listeners=PLAINTEXT://0.0.0.0:9092
advertised.listeners=PLAINTEXT://localhost:9092
# 以下两个配置必须配合使用, 即检查间隔时间必须小于等于offsets超时时间.
## Frequency at which to check for stale offsets
offsets.retention.check.interval.ms=60000
## Offsets older than this retention period will be discarded
offsets.retention.minutes=1
```

3. 将app/zookeeper/conf/中的zoo_sample.cfg重命名为"zoo.cfg"。
