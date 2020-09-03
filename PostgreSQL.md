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

# 管理工具

pgadmin
```
$ docker run -d --restart=always \
  -p 5433:80 \
  -e "PGADMIN_DEFAULT_EMAIL=p@g.cn" \
  -e "PGADMIN_DEFAULT_PASSWORD=postgres" \
  --name "postgres-pgadmin" dpage/pgadmin4:latest
```

psql
```
$ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' ;\
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - ;\
  sudo apt-get update ;\
  sudo apt install -y postgresql-client-12
```

---

# 扩展

## 文本搜索

[文本搜索](http://www.postgres.cn/docs/12/textsearch-intro.html) 默认不支持中文，安装[pg_cjk_parser](https://github.com/alx696/pg_cjk_parser)进行支持。
