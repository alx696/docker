#父镜像
FROM registry.cn-shanghai.aliyuncs.com/xm69/jre:openj9

ENV DEBIAN_FRONTEND="noninteractive" \
  ROCKSDB_VERSION="6.14.6"

RUN set -eux && \
  wget https://xm.lilu.red:444/soft/rocksdb-${ROCKSDB_VERSION}.tar.gz

RUN set -eux && \
  apt-get update && \
  apt-get install -y build-essential libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev && \
  tar zxf rocksdb-${ROCKSDB_VERSION}.tar.gz && \
  cd "rocksdb-${ROCKSDB_VERSION}" && \
  PORTABLE=1 make -j32 shared_lib && \
  make install-shared && \
  echo "/usr/local/lib" >> /etc/ld.so.conf && \
  ldconfig && \
  cd .. && \
  rm -rf ${ROCKSDB_VERSION}.tar.gz "rocksdb-${ROCKSDB_VERSION}" && \
  apt-get remove -y build-essential && \
  # 清理
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/*