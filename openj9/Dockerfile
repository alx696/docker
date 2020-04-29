FROM adoptopenjdk:14-jdk-openj9

ENV LANG="C.UTF-8" \
 DEBIAN_FRONTEND="noninteractive"

RUN \
  set -eux && \
  sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
  sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y apt-utils apt-transport-https && \
  apt-get upgrade -y && \
  apt-get install -y wget nano && \
  # 时区设为上海(注意:必须删除/etc/localtime,否则对时区的修改不会生效!)
  apt-get install -y tzdata && \
  rm /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  # 中文字体Noto Sans CJK SC Regular
  apt-get install -y fontconfig xfonts-utils && \
  mkdir -p /usr/share/fonts/ && \
  wget https://github.com/googlefonts/noto-cjk/raw/master/NotoSerifCJKsc-Regular.otf -O /usr/share/fonts/NotoSerifCJKsc-Regular.otf && \
#  wget https://172.17.0.1/NotoSerifCJKsc-Regular.otf --no-check-certificate -O /usr/share/fonts/NotoSerifCJKsc-Regular.otf && \
  fc-cache -f -v && \
  fc-list :lang=zh && \
  # 清理
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/* && \
  # Test
  java -version
