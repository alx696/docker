# 说明

映射文件夹到容器中, 然后通过启动参数指定sh脚本. 例如:
```
docker run -it --name myapp  xm69/openj9:14-sh /app/start.sh
```

# 构建

```
$ docker build -t xm69/openj9:14-sh .
```
