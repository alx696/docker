# 作为构建阶段使用，从源码编译体积较大且没有实现共享库的便携问题！
FROM alpine:3 AS builder
WORKDIR /home
RUN set -eux && \
  #显示信息
  echo "编译平台：$(uname -a)" && \
  #设置源
  echo "http://mirrors.ustc.edu.cn/alpine/edge/main/" > /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/community/" >> /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories && \
  apk update

# RocksDB安装方式1：从源码编译以支持老CPU（体积大）
RUN set -eux && \
  apk add linux-headers bash perl snappy-dev gflags-dev bzip2-dev lz4-dev zstd-dev zlib-dev build-base wget && \
  wget https://xm.lilu.red:444/soft/rocksdb-6.13.3.tar.gz && \
  tar zxf rocksdb-6.13.3.tar.gz && cd rocksdb-6.13.3 && \
  PORTABLE=1 PREFIX=/usr LIBDIR=/usr/lib make -j32 shared_lib
RUN set -eux && \
  cd rocksdb-6.13.3 && \
  cp librocksdb.so.6.13.3 /usr/lib/ && \
  cp -r include/* /usr/include/ && \
  cd /usr/lib/ && \
  ln -fs librocksdb.so.6.13.3 librocksdb.so.6.13 && \
  ln -fs librocksdb.so.6.13.3 librocksdb.so.6 && \
  ln -fs librocksdb.so.6.13.3 librocksdb.so && \
  cd /home/
# # RocksDB安装方式2：【推荐】直接安装RocksDB包
# RUN set -eux && \
#   apk add build-base rocksdb-dev
