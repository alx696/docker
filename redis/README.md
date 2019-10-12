# 特点

* 设置时区: **Asia/Shanghai**

# 运行示例

```
$ docker run -d -p 6379:6379 \
  --restart=always --name redis xm69/redis:5
```

# 构建

```
$ docker build -t xm69/redis:5 .
```
