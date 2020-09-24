#参考https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile

#增加模块:Header信息修改(例如Server)
#https://github.com/openresty/headers-more-nginx-module

#父镜像
FROM alpine:3

#nginx版本
ENV NGINX_VERSION 1.19.1

#复制资源
COPY ["resource/", "/resource/"]

#执行
RUN \
  && apk update \
  \
  #设置时区
  && apk add --no-cache tzdata \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone \
  && apk del tzdata \
  \
  #编译安装
  && apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		make \
		openssl-dev \
		pcre-dev \
		zlib-dev \
		linux-headers \
		curl \
		gnupg \
		libxslt-dev \
		gd-dev \
		geoip-dev \
  && curl -fSL https://nginx.org/download/nginx-$NGINX_VERSION.tar.gz -o nginx.tar.gz \
  && curl -fSL https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz -o headers.tar.gz \
  && tar zxf nginx.tar.gz \
  && tar zxf headers.tar.gz \
  && rm nginx.tar.gz headers.tar.gz \
  && mv nginx-${NGINX_VERSION} nginx \
  && mv headers-more-nginx-module-0.33 headers-more-nginx-module \
  && mv headers-more-nginx-module /resource/ \
  && cd nginx \
  && sh configure --prefix=/etc/nginx \
      --sbin-path=/usr/sbin/nginx \
		  --modules-path=/usr/lib/nginx/modules \
		  --conf-path=/etc/nginx/nginx.conf \
      --with-http_ssl_module \
      --with-http_v2_module \
      --with-http_gzip_static_module \
      --add-module=/resource/headers-more-nginx-module \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && cd ../ \
  && rm -rf nginx \
  #设置程序执行
  && apk add --no-cache --virtual .gettext gettext \
	&& mv /usr/bin/envsubst /tmp/ \
	&& runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)" \
	&& apk add --no-cache --virtual .nginx-rundeps $runDeps \
	&& apk del .build-deps \
	&& apk del .gettext \
	&& mv /tmp/envsubst /usr/local/bin/ \
  # 复制资源
  && mv /resource/tls/ /tls/ \
  && mv /resource/nginx.conf /etc/nginx/nginx.conf \
  && mv /resource/mime.types /etc/nginx/mime.types \
  # 创建服务目录
  && mkdir -p /logs /web \
  # forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx-error.log \
	&& ln -sf /dev/stderr /var/log/nginx-access.log \
  # 删除资源目录
  && rm -rf /resource

EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
