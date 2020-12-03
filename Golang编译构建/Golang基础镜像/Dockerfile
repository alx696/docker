#
# 构建应用
#
FROM golang:1.15-alpine AS builder
WORKDIR /home
COPY code .
ENV GOPROXY=https://goproxy.cn
RUN set -eux && \
  #设置源
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" > /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/community/" >> /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories && \
  apk update && \
  #安装GCC和RocksDB
  apk add --no-cache build-base rocksdb-dev && \
  #下载并校验Golang模块
  go mod download && go mod verify && \
  #编译Golang应用
  go build -o /home/main

################

#
# 封装镜像
#
FROM alpine:3
WORKDIR /home
#从构建阶段中复制程序
COPY --from=builder /home/main .
#从资源文件夹中复制资源
COPY resource .
RUN set -eux && \
  #设置源
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" > /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/community/" >> /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories && \
  apk update && \
  \
  #设置时区
  apk add --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  apk del tzdata && \
  #安装RocksDB
  apk add --no-cache rocksdb

ENTRYPOINT ["./main"]

EXPOSE 40000