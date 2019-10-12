FROM openjdk:13-slim

ENV LANG="C.UTF-8" \
 DEBIAN_FRONTEND="noninteractive"

RUN \
  set -eux && \
  sed -i s/deb.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
  sed -i s/security.debian.org/mirrors.aliyun.com/g /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y apt-utils && \
  apt-get install -y apt-transport-https && \
  apt-get upgrade -y && \
  apt-get install -y wget nano && \
  # 时区设为上海
  apt-get install -y tzdata && \
  #注意:必须删除/etc/localtime,否则该/etc/timezone方式对时区的修改不会生效!
  rm /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  # 中文字体Noto Sans CJK SC Regular
  apt-get install -y fontconfig xfonts-utils && \
  mkdir -p /usr/share/fonts/ && \
  wget https://storage.googleapis.com/xm-bucket/public/NotoSerifCJKsc-Regular.otf -O /usr/share/fonts/NotoSerifCJKsc-Regular.otf && \
  fc-cache -f -v && \
  fc-list :lang=zh && \
  # 清理
  apt-get autoremove && \
  apt-get autoclean && \
  rm -rf /var/lib/apt/lists/* && \
  # Test
  java -version
