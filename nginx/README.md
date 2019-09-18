# 配置文件路径
`/etc/nginx/nginx.conf`

# web目录路径
`/web`

# 证书路径
* 证书 `/tls/server.cer`
* 密钥 `/tls/server.key`

# 运行示例
```
$ docker run -d --restart=always \
  -p 80:80 -p 443:443 \
  -v ${PWD}/web:/web \
  --name "nginx" xm69/nginx:1.17
```

# 构建
```
$ docker build -t xm69/nginx:1.17 .
```
