## 概述

可以直接使用[postgres](https://hub.docker.com/_/postgres)或[postgis](https://hub.docker.com/r/postgis/postgis)。

## 运行示例

```
$ docker run -d --restart=always \
  -p 5432:5432 \
  -v "${PWD}/postgres":/data \
  -e PGDATA=/data -e TZ=Asia/Shanghai -e POSTGRES_PASSWORD=postgres \
  --name "postgres" postgres:13-alpine \
  -c "max_connections=1000" \
  -c "shared_buffers=4GB" \
  -c "effective_cache_size=8GB" \
  -c "work_mem=64MB" \
  -c "maintenance_work_mem=2GB" \
  -c "checkpoint_completion_target=0.9" \
  -c "random_page_cost=1.1" \
  -c "effective_io_concurrency=200" \
  -c "min_wal_size=4GB" \
  -c "max_wal_size=8GB" \
  -c "default_statistics_target=500" \
  -c "jit=off" \
  -c "log_statement=all" \
  -c "log_min_duration_statement=1000" \
  -c "log_connections=true" \
  -c "log_disconnections=true" \
  -c "log_line_prefix='%m [%p] [%r] '"
```
> [参考日志文档](http://postgres.cn/docs/12/runtime-config-logging.html) 进入生成环境后可将`log_statement`设为`none`关闭所有执行语句的记录。

## 管理工具

### pgadmin
```
$ docker run -d --restart=always \
  -p 5433:80 \
  -e "PGADMIN_DEFAULT_EMAIL=p@g.cn" \
  -e "PGADMIN_DEFAULT_PASSWORD=p" \
  --name "postgres-pgadmin" dpage/pgadmin4:latest
```

### psql

容器：
```
# 进入psql
$ docker run -it --rm --link 数据库容器名称:ph \
  postgres:13 psql -h ph -d postgres -U postgres

# 直接执行命令
$ docker exec -i 容器名称 psql --dbname=postgres --username=postgres -c "drop table infrastructure_detection_point_data;"
```
> [参考](http://postgres.cn/docs/13/app-psql.html) `\q`退出

操作系统：
```
$ sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' ;\
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - ;\
  sudo apt-get update ;\
  sudo apt install -y postgresql-client-13
```

## 备份

```
# 指定schema备份（千万不要设置`--verbose`等输出日志内容到控制台的参数）
docker exec -t 容器名称 pg_dump --dbname=postgres --username=postgres --clean --if-exists --no-owner --schema=public > "postgres.dump"

# 可以输出日志的备份
docker exec -t 容器名称 pg_dump --verbose --dbname=postgres --username=postgres --clean --if-exists --no-owner --schema=public --file="/data/postgres.dump" \
&& docker cp 容器名称:/data/postgres.dump ./
```

## 恢复

```
cat "postgres.dump" | docker exec -i 容器名称 psql --dbname=postgres --username=postgres
```

---

# 扩展

## 文本搜索

[文本搜索](http://www.postgres.cn/docs/12/textsearch-intro.html) 默认不支持中文，安装[pg_cjk_parser](https://github.com/alx696/pg_cjk_parser)进行支持。
