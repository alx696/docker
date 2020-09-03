# 说明

PostgreSQL读写分离，读负载均衡代理。

## 端口

* `40000`：状态页面
* `40001`：PostgreSQL读写端口
* `40002`：PostgreSQL读负载均衡端口

# 运行示例

```
$ docker run -d --restart=always \
  -p 40000:40000 \
  -p 40001:40001 \
  -p 40002:40002 \
  --name haproxy_postgres xm69/haproxy:postgres
```

也可直接映射配置运行：
```
$ docker run -d --restart=always \
  -p 40000:40000 \
  -p 40001:40001 \
  -p 40002:40002 \
  -v $PWD/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg \
  --name haproxy_postgres haproxy:2.2
```

# 构建

```
$ docker build -t xm69/haproxy:postgres .
```

# 参考

https://www.percona.com/blog/2019/11/08/configure-haproxy-with-postgresql-using-built-in-pgsql-check/

https://severalnines.com/database-blog/database-load-balancing-using-haproxy-amazon-aws