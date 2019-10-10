FROM openjdk:13-alpine

ENV LANG C.UTF-8
ENV ALPINE_MIRROR https://mirrors.aliyun.com/alpine/latest-stable

RUN echo "$ALPINE_MIRROR/main/" > /etc/apk/repositories \
  && echo "$ALPINE_MIRROR/community/" >> /etc/apk/repositories \
  && apk update \
  \
  #设置时区
  && apk add --no-cache tzdata \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata \
  \
  #中文字体
  && apk add --no-cache fontconfig xfontsel curl \
  && curl -O https://np.lilu.red:81/file/font/NotoSansCJKsc-Regular.otf \
  && mkdir -p /usr/share/fonts \
  && mv NotoSansCJKsc-Regular.otf /usr/share/fonts/ \
  && fc-cache -f -v \
  && fc-list :lang=zh \
  \
  && java -version
