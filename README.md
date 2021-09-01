## 清理
* 综合清理: `$ docker system prune` . 不会删除未被使用的本地卷和未被使用的镜像, 加上参数 `--all --volumes`将删除这些.
* 删除所有6小时前处于停止状态的容器: `$ docker container prune --filter "until=6h"`
* 删除所有dangling和未被使用的镜像: `$ docker image prune --all`
* 删除所有未被使用的本地卷: `$ docker volume prune`
* 删除所有未被使用的网络: `$ docker network prune`
* 删除btrfs挂载: `# cd /var/lib/docker && \ btrfs subvolume delete btrfs/subvolumes/*`

## 容器
* 存为镜像: `$ docker commit 容器名称 镜像名称:版本` (尽量不用, 镜像体积会越来越大)
* 查看日志: `$ docker logs -f --tail 10 容器名称`
* 复制文件：`$ docker cp 容器ID或名称:/path/to/file .` 从容器中复制文件到当前目录

### 设置连接数量

在Linux内核小于5.3的系统中，容器中默认`net.core.somaxconn`只有128,且设置系统的`/etc/sysctl.conf`并不能改变容器中的值。

如果需要扩大，需在容器启动时设置参数`--sysctl net.core.somaxconn=64000`。进入容器后执行`cat /proc/sys/net/core/somaxconn`可以查看。

> 测试发现好像没有实际起到作用？

### 赋予特权

有时我们需要容器具有最高权限, 这时可以在启动时增加`--privileged`参数. 显著特性是容器可以访问主机所有设备了, [详细文档](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities);

## 镜像
*  保存为本地文件: `$ docker save -o 本地文件名字.tar 镜像1:版本 镜像2:版本`
*  从本地文件恢复: `$ docker load < 本地文件名字.tar`
*  删除所有镜像: `$ docker rmi -f $(docker images -q)`
*  删除REPOSITORY为none的镜像: `$ docker rmi $(docker images | grep "^<none>" | awk "{print $3}")`
*  删除TAG为none的镜像: `$ docker rmi -f $(docker images -f dangling=true -q)`

## 默认配置

```
$ sudo mkdir /etc/docker && echo '{
  "data-root": "/home/docker",
  "log-driver": "json-file",
  "log-opts": {
    "mode": "non-blocking",
    "max-buffer-size": "3m",
    "max-size": "3m",
    "max-file": "3"
  }
}' | sudo tee -a /etc/docker/daemon.json
```
>  默认情况下日志过多会占用大量的硬盘空间, 日志位置: /var/lib/docker/containers/容器哈希/容器哈希-json.log . 设置仅对新创建容器有效!!! 针对现有容器可以执行 `truncate -s 0 /var/lib/docker/containers/*/*-json.log` 手动清空.

## 离线安装

[下载3个软件包](https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/),按照下面步骤安装:

1. 安装依赖
2. 安装containerd.io
3. 安装docker-ce-cli
4. 安装docker-ce
5. 设置用户组 `$ sudo usermod -aG docker $USER`
> 参考 https://docs.docker.com/engine/install/ubuntu/#install-from-a-package

## 在线安装

```
 curl -fsSL https://get.docker.com -o get-docker.sh
 sudo sh get-docker.sh --mirror Aliyun
 sudo usermod -aG docker $USER
```
> 参考 https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script

## 访问控制
在对安全性有要求的项目中，需要禁用一些端口从服务器外访问。网上很多资料已经过时，测试发现Docker会自动配置iptables以公开映射到主机的端口，可以通过在 `/etc/docker/daemon.json` 中添加 `"iptables": false` 配置来关闭自动公开。但是如果关闭了自动公开，nginx就无法获取remote_addr(即客户真实IP)，会带来一些无法预料的问题。**推荐使用自定义网卡（user-defined bridge network）来关联容器，对主机只暴露需要公开的端口。**

## 自建registry server

> 参考 https://docs.docker.com/registry/deploying/

```
$ docker run -d --restart=always \
  -v ${PWD}/registry:/var/lib/registry \
  -v ~/docker/tls/:/certs/ \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:3000 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/fullchain.pem \
  -e REGISTRY_HTTP_TLS_KEY=/certs/privkey.pem \
  -p 3000:3000 \
  --name registry \
  registry:2
```
> 注意: REGISTRY_HTTP_ADDR的端口与p参数的要内外一致.

## 特殊问题

### Restarting (132)

家里一台老电脑CPU是AMD A6-3670 APU，运行go-file容器时容器一直重启，状态为`Restarting (132)`，没有任何日志。反复尝试多次重新编译镜像，问题不能解决。开发机CPU为Intel(R) Core(TM) i5-8600K是支持的，运行正常。查询CPU信息的命令为`$ cat /proc/cpuinfo`

通过直接添加RocksDB共享库的方式，直接编译golang程序则能够运行。参考两个类似问题[1](https://stackoverflow.com/questions/49198919/kong-official-docker-images-broken),[2](https://github.com/Kong/docker-kong/issues/138#issuecomment-449423106)，估计是RocksDB编译的指令sse4_2在老CPU中不支持导致。
