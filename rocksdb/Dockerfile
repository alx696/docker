#父镜像
FROM debian:buster

ENV LANG="C.UTF-8" \
 DEBIAN_FRONTEND="noninteractive" \
 ROCKSDB_VERSION="6.5"

#执行
RUN \
  set -eux && \
  sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
  sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y apt-utils apt-transport-https && \
  apt-get upgrade -y && \
  # 时区设为上海(注意:必须删除/etc/localtime,否则对时区的修改不会生效!)
  apt-get install -y tzdata && \
  rm /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  # 安装工具
  apt-get install -y nano wget unzip && \
  # RocksDB库
  apt-get install -y build-essential libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev && \
  wget https://github.com/facebook/rocksdb/archive/${ROCKSDB_VERSION}.fb.zip && \
  unzip ${ROCKSDB_VERSION}.fb.zip && \
  cd rocksdb-${ROCKSDB_VERSION}.fb && \
  PORTABLE=1 make -j32 shared_lib && \
  make install-shared && \
  echo "/usr/local/lib" >> /etc/ld.so.conf && \
  ldconfig && \
  cd .. && \
  rm -rf ${ROCKSDB_VERSION}.fb.zip "rocksdb-${ROCKSDB_VERSION}.fb" && \
  apt-get remove -y build-essential && \
  # 清理
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/*