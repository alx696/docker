# 特点

* 设置时区: **Asia/Shanghai**

# 运行示例

```
$ docker run -d -p 6379:6379 \
  -v ${PWD}/redis:/data \
  --restart=always --name redis xm69/redis:6 \
  redis-server --appendonly yes --requirepass mima
```

# 构建

```
$ docker build -t xm69/redis:6 .
```
