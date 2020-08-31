## 安装

[参考文档](https://www.tecmint.com/configure-postgresql-streaming-replication-in-centos-8/)
> 注意：PostgreSQL 12相比老版配置起来更加简单，步骤也不相同！

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
$ sudo apt install -y postgresql-client

$ psql -U postgres -h localhost -p 40001 -d postgres

ALTER SYSTEM SET listen_addresses TO '*';

CREATE ROLE ru WITH REPLICATION PASSWORD 'ru' LOGIN;

\q

$ docker restart db-m
```
> 询问`Password for user postgres:`时输入`postgres`。

### 从机

> 注意：这是从机上执行的命令！

安装工具并进行设置：
```
$ sudo apt install -y postgresql-client
$ sudo pg_basebackup -h 192.168.1.200 -p 40001 -D ${PWD}/db-s1/db -U ru -P -v  -R -X stream -C -S slot1
```
> `192.168.1.200`为主机的IP！询问`Password:`时输入`ru`。终端打印“pg_basebackup: base backup completed”说明此步骤成功。`slot1`为Replication Slots。

```
$ sudo chmod -R 777 db-s1

$ docker run -d --restart=always \
  -p 40002:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -e TZ=Asia/Shanghai \
  -e PGDATA=/data/db \
  -v ${PWD}/db-s1:/data \
  --name db-s1 timescale/timescaledb:latest-pg12 \
  -c "max_connections=100" \
  -c "jit=off"
```

验证：
```
$ docker logs --tail 6 db-s1
```
输出如下字样：
```
2020-08-31 16:18:24.506 CST [27] LOG:  database system was interrupted; last known up at 2020-08-31 16:17:36 CST
2020-08-31 16:18:24.580 CST [27] LOG:  entering standby mode
2020-08-31 16:18:24.599 CST [27] LOG:  redo starts at 0/4000028
2020-08-31 16:18:24.604 CST [27] LOG:  consistent recovery state reached at 0/4000100
2020-08-31 16:18:24.604 CST [1] LOG:  database system is ready to accept read only connections
2020-08-31 16:18:24.611 CST [31] LOG:  started streaming WAL from primary at 0/5000000 on timeline 1
```
> 最后一行为"started streaming WAL from primary..."说明配置成功。

## 验证

在主机上执行：
```
$ psql -U postgres -h localhost -p 40001 -d postgres
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