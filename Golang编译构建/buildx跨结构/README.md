## 特点

使用buildx:
```
docker buildx build --platform linux/arm64 -t xm69/service-file:1 . --load
```
> 注意：只有--push推送模式时才支持同时构建多个平台，--load只能单个平台.

### 优势

可以跨结构构建，比如在amd64上构建arm64镜像。

### 缺点

没有build通用，某些情况下会报错。构建速度慢，比buid慢不少。比如使用Golang基础镜像时，go丢失了执行路径。