# 注意

现在 https://hub.docker.com/r/postgis/postgis 提供了官方镜像, 可以直接使用!

# 特点

* 安装PostGIS 2.5

# 运行示例

```
$ docker run -d --restart=always \
-v ${PWD}/postgres:/data \
-p 5432:5432 \
-e PGDATA=/data -e TZ=Asia/Shanghai -e POSTGRES_PASSWORD=postgres \
--name "postgres" postgis/postgis:12-3.0
```

# 构建

```
$ docker build -t xm69/postgres:11-gis2.5 .
```

# 推送

```bash
tag="xm69/postgres:11-gis2.5" \ &&
docker tag ${tag} registry.cn-hangzhou.aliyuncs.com/${tag} \ &&
docker push registry.cn-hangzhou.aliyuncs.com/${tag}
```
