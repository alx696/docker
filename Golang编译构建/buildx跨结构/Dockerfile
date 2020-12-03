#
# 构建应用
#
FROM alpine:3 AS builder
WORKDIR /home
COPY code .
ENV GOPROXY=https://goproxy.cn
ARG TARGETOS
ARG TARGETARCH
RUN set -eux && \
  #设置源
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" > /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/community/" >> /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories && \
  apk update && \
  #安装GCC和RocksDB
  apk add --no-cache build-base rocksdb-dev go && \
  #打印信息
  echo "目标系统：${TARGETOS}，目标结构：${TARGETARCH}，编译平台：$(uname -a)" && \
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