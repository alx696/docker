#父镜像
FROM redis:5-alpine

#环境变量
ENV ALPINE_MIRROR https://mirrors.aliyun.com/alpine/latest-stable

#执行
RUN echo "$ALPINE_MIRROR/main/" > /etc/apk/repositories \
  && echo "$ALPINE_MIRROR/community/" >> /etc/apk/repositories \
  && apk update \
  \
  #设置时区
  && apk add --no-cache tzdata \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server"]
