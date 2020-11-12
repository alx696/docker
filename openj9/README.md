## 特点

* 基础镜像: https://github.com/docker-library/docs/blob/master/adoptopenjdk/README.md#shared-tags
* 设置时区: **Asia/Shanghai**
* 中文字体: **Noto Serif CJK SC** 样式**Regular**, `/usr/share/fonts/NotoSerifCJKsc-Regular.otf: Noto Serif CJK SC:style=Regular`
* 安装wget, nano
* apt源设为aliyun.com

## 构建

```
$ docker build -t xm69/openj9:14 .
```

## 测试

```
$ docker run -it --rm xm69/openj9:14 java -version
```

## 使用

### 启动应用

将应用目录映射到容器中, 然后通过运行参数启动应用入口:
```
$ docker run -d --restart=always \
  -p 10000:6000 \
  -e POSTGRES_JDBC="jdbc:postgresql://172.17.0.1:10010" \
  -v ${PWD}/grpc:/app \
  --name "java-grpc" xm69/openj9:14 \
  /app/bin/grpc
```
> 说明: `/app/bin/grpc`为应用入口.