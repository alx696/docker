安装了PostGIS 2.5.

# 运行示例
```
$ docker run -d --restart=always \
-v ${PWD}/postgres:/data \
-p 65432:5432 \
-e PGDATA=/data -e TZ=Asia/Shanghai -e POSTGRES_PASSWORD=any_password \
--name "postgres" xm69/postgres:postgis-2.5
```
