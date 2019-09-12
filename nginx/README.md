# 所用配置文件
`/etc/nginx/nginx.conf`

```
user root;
worker_processes auto;

error_log  /logs/error.log  notice;
pid /var/run/nginx.pid;

events
{
  worker_connections 1024;
}

http
{
  include mime.types;
  default_type application/octet-stream;

  log_format  main  '[$remote_addr:$remote_port] $time_local '
                    '"$request"($body_bytes_sent) $status';

  access_log  /logs/access.log  main;
  sendfile on;

  keepalive_timeout 65;

  gzip  on;

  charset utf8;

  # Hide version
  #server_tokens off;
  # Hide Server Header
  #more_clear_headers 'Server';
  # Change Server Header
  #more_set_headers 'Server: Guess What';

  server
  {
    listen 80;
    return 301 https://$host$request_uri;
  }

  server
  {
    listen 443 ssl;
    ## Auto redirect http on special port to https
    #error_page 497 https://$host:444$request_uri;
    ssl on;
    ssl_session_cache shared:SSL:15m;
    ssl_session_timeout 15m;
    ssl_certificate /tls/server.cer;
    ssl_certificate_key /tls/server.key;
    ssl_protocols TLSv1.2;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /web;
    location / {
      index index.html;
      #autoindex on;
      #autoindex_exact_size on;
      #autoindex_localtime on;
    }

    # Real IP
    proxy_set_header X-Remote-Addr $remote_addr;

    ## Grpc WebSocket Proxy
    #location /API-GRPC/ {
    #  #Notice IP and Port
    #  proxy_pass http://172.17.0.1:6001/;
    #  proxy_http_version 1.1;
    #  proxy_set_header Upgrade $http_upgrade;
    #  proxy_set_header Connection "Upgrade";
    #}

    ## REST
    #location /API-REST/ {
    #  #Notice IP and Port
    #  proxy_pass http://172.17.0.1:6002/v1/;
    #}
  }
}
```

# web目录路径
`/web`

# 证书路径
* `/tls/server.cer` 证书
* `/tls/server.key` 私钥

# 运行示例
```
$ docker run -d --restart=always \
  -p 80:80 -p 443:443 \
  -v ${PWD}/html:/web \
  --name "nginx" xm69/nginx:alpine-1.17
```

# 构建
```
$ docker build -t xm69/nginx:1.17 .
```
> 注意: 以子模块形式引用了**headers-more-nginx-module**, 构建前记得执行 `git submodule update --init --recursive` 拉取.
