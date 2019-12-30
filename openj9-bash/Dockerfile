#父镜像
FROM xm69/openj9:11

#工作目录
WORKDIR /app

#复制脚本
COPY ["resource/", "/resource/"]

RUN \
  mv /resource/entrypoint.sh / && \
  chmod +x /entrypoint.sh

#入口
ENTRYPOINT ["/entrypoint.sh"]
