## 安装

[参考文档](https://www.tecmint.com/configure-postgresql-streaming-replication-in-centos-8/)
> 注意：PostgreSQL 12相比老版配置起来更加简单，步骤也不相同！

### 主机

```
$ docker run -d --restart=always \
  -v ${PWD}/postgres-m:/data \
  -p 5434:5432 \
  -e PGDATA=/data -e TZ=Asia/Shanghai -e POSTGRES_PASSWORD=postgres \
  --name "postgres-m" postgres:12 \
  -c "max_connections=100" \
  -c "shared_buffers=4GB" \
  -c "effective_cache_size=12GB" \
  -c "work_mem=64MB" \
  -c "maintenance_work_mem=2GB" \
  -c "checkpoint_completion_target=0.9" \
  -c "random_page_cost=1.1" \
  -c "effective_io_concurrency=200" \
  -c "min_wal_size=4GB" \
  -c "max_wal_size=8GB" \
  -c "default_statistics_target=500" \
  -c "jit=off"

$ echo "host replication all all md5" | sudo tee -a ${PWD}/db-m/db/pg_hba.conf
```

安装工具并进行集群初始设置：
```
$ sudo apt install -y postgresql-client
$ psql -U postgres -h localhost -p 5434 -d postgres

ALTER SYSTEM SET listen_addresses TO '*';

CREATE ROLE ru WITH REPLICATION PASSWORD 'ru' LOGIN;

\q

$ docker restart postgres-m
```
> 询问`Password for user postgres:`时输入`postgres`。

### 从机

> 注意：这是从机上执行的命令！

安装工具并进行设置：
```
$ sudo apt install -y postgresql-client
$ sudo pg_basebackup -h 192.168.1.200 -p 5434 -D ${PWD}/postgres-s1 -U ru -P -v  -R -X stream -C -S slot1
```
> `192.168.1.200`为主机的IP！询问`Password:`时输入`ru`。终端打印“pg_basebackup: base backup completed”说明此步骤成功。`slot1`为Replication Slots。

```
$ docker run -d --restart=always \
  -v ${PWD}/postgres-s1:/data \
  -p 5435:5432 \
  -e PGDATA=/data -e TZ=Asia/Shanghai -e POSTGRES_PASSWORD=postgres \
  --name "postgres-s1" postgres:12 \
  -c "max_connections=100" \
  -c "shared_buffers=4GB" \
  -c "effective_cache_size=12GB" \
  -c "work_mem=64MB" \
  -c "maintenance_work_mem=2GB" \
  -c "checkpoint_completion_target=0.9" \
  -c "random_page_cost=1.1" \
  -c "effective_io_concurrency=200" \
  -c "min_wal_size=4GB" \
  -c "max_wal_size=8GB" \
  -c "default_statistics_target=500" \
  -c "jit=off"
```

验证：
```
$ docker logs --tail 6 postgres-s1
```
输出最后一行为"started streaming WAL from primary..."说明配置成功。

## 验证

在主机上执行：
```
$ psql -U postgres -h localhost -p 5434 -d postgres
```
输入密码`postgres`，执行：
```
SELECT * FROM pg_stat_replication;
```
输入类似下面内容说明成功：
```
 pid | usesysid | usename | application_name | client_addr | client_hostname | client_port |         backend_start         | backend_xmin |   state   | sent_lsn  | write_lsn | flush_lsn | replay_lsn | write_lag | flush_lag | replay_lag | sync_priority | sync_state |          reply_time           
-----+----------+---------+------------------+-------------+-----------------+-------------+-------------------------------+--------------+-----------+-----------+-----------+-----------+------------+-----------+-----------+------------+---------------+------------+-------------------------------
  32 |    16384 | ru      | walreceiver      | 172.17.0.1  |                 |       50474 | 2020-08-31 15:58:50.518916+08 |              | streaming | 0/5000148 | 0/5000148 | 0/5000148 | 0/5000148  |           |           |            |             0 | async      | 2020-08-31 16:24:29.773652+08
```
> 按`\`再按`q`出来，输入`\q`按回车回到命令行。如需进一步验证，可以在主机创建一个表，从机也会自动创建。