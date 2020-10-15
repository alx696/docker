## 文件

* `证书库` 放置服务器证书密钥及其根证书, 对应内部路径`/server/ssl/keystore.jks`

## 端口

* `9092` 明文
* `9093` 加密且验证客户端证书

## 环境变量

* `KEYSTORE_PASSWORD` 证书库密码
* `IP` 最终提供服务IP, 如要公网使用此处设置公网IP
* `PLAINTEXT_PORT` 非加密端口, 对应内部端口`9092`
* `SSL_PORT` 加密端口, 对应内部端口`9093`

### 运行示例

```
$ docker run -d --restart=always \
  -p 39092:9092 \
  -p 39093:9093 \
  -v $PWD/kafka.keystore.jks:/server/ssl/keystore.jks \
  -e KEYSTORE_PASSWORD="123456" \
  -e IP="192.168.1.200" \
  -e PLAINTEXT_PORT="39092" \
  -e SSL_PORT="39093" \
  --name "kafka" xm69/kafka:2.6
```

### 构建

```
$ docker build -t xm69/kafka:2.6 .
```

### 镜像制作要点

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
