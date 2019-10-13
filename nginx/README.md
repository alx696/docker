# 特点

1. 时区设为上海；
2. 支持自定义服务器信息；
3. 支持wasm, 为其启用**gzip_static**；
4. 默认启用TLS1.2(1.3Android不支持!), 内置开发证书；
5. 内置禁止浏览器缓存模板.

# 设置

## 配置文件路径
`/etc/nginx/nginx.conf`

## web目录路径
`/web`

## 证书路径
* 证书 `/tls/server.cer`
* 密钥 `/tls/server.key`

# 运行示例

```
$ docker run -d --restart=always \
  -p 80:80 -p 443:443 \
  -v ${PWD}/web:/web \
  --name "nginx" xm69/nginx:1.17
```

## 映射配置和证书

```
docker run -d --restart=always \
  -p 80:80 -p 443:443 \
  -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf \
  -v ${PWD}/web:/web \
  -v /etc/letsencrypt/live/app.lilu.red/fullchain.pem:/tls/server.cer \
  -v /etc/letsencrypt/live/app.lilu.red/privkey.pem:/tls/server.key \
  --name "nginx" xm69/nginx:1.17
```

# 构建
```
$ docker build -t xm69/nginx:1.17 .
```
