# 常用

## 清理
* 综合清理: `$ docker system prune` . 不会删除未被使用的本地卷和未被使用的镜像, 加上参数 `--all --volumes`将删除这些.
* 删除所有6小时前处于停止状态的容器: `$ docker container prune --filter "until=6h"`
* 删除所有dangling和未被使用的镜像: `$ docker image prune --all`
* 删除所有未被使用的本地卷: `$ docker volume prune`
* 删除所有未被使用的网络: `$ docker network prune`
* 删除btrfs挂载: `# cd /var/lib/docker && \ btrfs subvolume delete btrfs/subvolumes/*`

## 容器
*  存为镜像: `$ docker commit 容器名称 镜像名称:版本` (尽量不用, 镜像体积会越来越大)
*  查看日志: `$ docker logs -f --tail 10 容器名称`

## 镜像
*  保存为本地文件: `$ docker save -o 本地文件名字.tar 镜像1:版本 镜像2:版本`
*  从本地文件恢复: `$ docker load < 本地文件名字.tar`
*  删除所有镜像: `$ docker rmi -f $(docker images -q)`
*  删除REPOSITORY为none的镜像: `$ docker rmi $(docker images | grep "^<none>" | awk "{print $3}")`
*  删除TAG为none的镜像: `$ docker rmi -f $(docker images -f dangling=true -q)`

# 安装

## 在线安装

```
$ wget https://get.docker.com -O get-docker.sh && \
  sudo sh get-docker.sh --mirror Aliyun && \
  sudo usermod -aG docker $USER
```
> 参考 https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-convenience-script

## 离线安装

1. 安装依赖
2. 安装containerd.io
3. 安装docker-ce-cli
4. 安装docker-ce
5. 设置用户组 `$ sudo usermod -aG docker $USER`
> 参考 https://docs.docker.com/engine/install/ubuntu/#install-from-a-package
> 地址(20.04) https://download.docker.com/linux/ubuntu/dists/focal/pool/stable/amd64/

# 设置
参考 https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file

## 防止日志占用过多硬盘空间
*  参考 https://stackoverflow.com/questions/42510002/how-to-clear-the-logs-properly-for-a-docker-container/42510314
*  参考 https://docs.docker.com/config/containers/logging/json-file/

在 **/etc/docker/daemon.json** 中添加配置:
```
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "16m",
    "max-file": "3"
  }
}
```
>  默认情况下日志过多会占用大量的硬盘空间, 日志位置: /var/lib/docker/containers/容器哈希/容器哈希-json.log . 设置仅对新创建容器有效!!! 针对现有容器可以执行 `truncate -s 0 /var/lib/docker/containers/*/*-json.log` 手动清空.

## ulimits
使用时发现如果高频率大数据量在PostgreSQL中插入JSONB类型数据时, 容易触发 Resource temporarily unavailable 和 No space left on device 问题. 经确认增加ulimits中的**open files**数量可以解决此问题.

在 **/etc/docker/daemon.json** 中添加配置:
```
{
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 64000,
      "Soft": 64000
    }
  }
}
```
>  此方式未测试.

## 访问控制
在对安全性有要求的项目中，需要禁用一些端口从服务器外访问。网上很多资料已经过时，测试发现Docker会自动配置iptables以公开映射到主机的端口，可以通过在 `/etc/docker/daemon.json` 中添加 `"iptables": false` 配置来关闭自动公开。但是如果关闭了自动公开，nginx就无法获取remote_addr(即客户真实IP)，会带来一些无法预料的问题。**推荐使用自定义网卡（user-defined bridge network）来关联容器，对主机只暴露需要公开的端口。**

# 自建registry server

> 参考 https://docs.docker.com/registry/deploying/

```
$  docker run -d --restart=always \
  -v ${PWD}/registry:/var/lib/registry \
  -v /etc/letsencrypt/live/np.lilu.red/fullchain.pem:/certs/server.cer \
  -v /etc/letsencrypt/live/np.lilu.red/privkey.pem:/certs/server.key \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:86 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/server.cer \
  -e REGISTRY_HTTP_TLS_KEY=/certs/server.key \
  -p 86:86 \
  --name registry \
  registry
```
> 注意: REGISTRY_HTTP_ADDR的端口与p参数的要内外一致.
