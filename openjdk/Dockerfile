FROM openjdk:13-alpine

ENV LANG C.UTF-8

RUN echo "http://mirrors.aliyun.com/alpine/v3.9/main/" > /etc/apk/repositories \
  && echo "http://mirrors.aliyun.com/alpine/v3.9/community/" >> /etc/apk/repositories \
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
