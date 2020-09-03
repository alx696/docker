## 安装

[参考文档](https://www.tecmint.com/configure-postgresql-streaming-replication-in-centos-8/)
> 注意：PostgreSQL 12相比老版配置起来更加简单，步骤也不相同！TimescaleDB的Docker容器在初始化时会自动应用优化配置，基本配置无需调节。

### 主机

```
$ docker run -d --restart=always \
  -p 40001:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -e TZ=Asia/Shanghai \
  -e PGDATA=/data/db \
  -v ${PWD}/db-m:/data \
  --name db-m timescale/timescaledb:latest-pg12 \
  -c "max_connections=100" \
  -c "jit=off"

$ echo "host replication all all md5" | sudo tee -a ${PWD}/db-m/db/pg_hba.conf
```

安装工具并进行集群初始设置：
```
$ docker run -it --rm -e PGPASSWORD="postgres" \
  timescale/timescaledb:latest-pg12 \
  psql --host=172.17.0.1 --port=40001 --dbname=postgres --username=postgres

ALTER SYSTEM SET listen_addresses TO '*';

CREATE ROLE ru WITH REPLICATION PASSWORD 'ru' LOGIN;

\q

$ docker restart db-m
```

### 从机

> 注意：这是从机上执行的命令！

安装工具并进行设置：
```
$ docker run -it --rm -e PGPASSWORD="ru" \
  -v $PWD/db-s1:/temp \
  timescale/timescaledb:latest-pg12 \
  pg_basebackup --host=192.168.1.2 --port=40001 \
  -D /temp/db -U ru -P -v  -R -X stream -C -S slot1
```
> `192.168.1.2`为主机的IP，`slot1`为Replication Slots。终端输出：“pg_basebackup: base backup completed”说明此步骤成功。

```
$ sudo chmod -R 777 db-s1

$ docker run -d --restart=always \
  -p 40001:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -e TZ=Asia/Shanghai \
  -e PGDATA=/data/db \
  -v ${PWD}/db-s1:/data \
  --name db-s1 timescale/timescaledb:latest-pg12 \
  -c "max_connections=100" \
  -c "jit=off"
```

稍等1分钟左右，验证：
```
$ docker logs --tail 6 db-s1
```
输出最后一行含"started streaming WAL from primary..."说明配置成功。

## 验证

在主机上执行：
```
$ docker run -it --rm -e PGPASSWORD="postgres" \
  timescale/timescaledb:latest-pg12 \
  psql --host=172.17.0.1 --port=40001 --dbname=postgres --username=postgres \
  -c "SELECT * FROM pg_stat_replication;"
```
终端输出类似下面内容：
```
 pid | usesysid | usename | application_name | client_addr | client_hostname | client_port |         backend_start         | backend_xmin |   state   | sent_lsn  | write_lsn | flush_lsn | replay_lsn | write_lag | flush_lag | replay_lag | sync_priority | sync_state |          reply_time           
-----+----------+---------+------------------+-------------+-----------------+-------------+-------------------------------+--------------+-----------+-----------+-----------+-----------+------------+-----------+-----------+------------+---------------+------------+-------------------------------
  75 |    17468 | ru      | walreceiver      | 192.168.1.7 |                 |       55624 | 2020-09-03 16:15:25.029047+08 |              | streaming | 0/3000060 | 0/3000060 | 0/3000060 | 0/3000060  |           |           |            |             0 | async      | 2020-09-03 16:16:45.205935+08
(1 row)
```
> 最后一行为`(1 row)`说明配置成功。