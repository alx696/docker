# 注意

实测并不成功，老是报一些没有配置的奇怪错误。

### 安装依赖

```
$ sudo apt install -y gcc make libpq-dev postgresql-client
```

### 编译安装

> 提示：源码编译安装时，示例配置文件夹路径为`/usr/local/etc`。

[下载源码](http://www.pgpool.net/download.php?f=pgpool-II-4.1.3.tar.gz) ，解压并进入源码目录：
```
$ ./configure ;\
  make -j 32 ;\
  sudo make install ;\
  sudo mkdir -p /var/log/pgpool/ ;\
  sudo cp /usr/local/etc/pgpool.conf.sample /usr/local/etc/pgpool.conf ;\
  sudo nano /usr/local/etc/pgpool.conf
```
修改`listen_addresses = '*'`，修改`pid_file_name = 'pgpool.pid'`，将其中`# - Backend Connection Settings -`行到`# - Authentication -`行之间的内容替换为：
```
backend_hostname0 = '192.168.1.2'
backend_port0 = 40001
backend_weight0 = 1
backend_hostname1 = '192.168.1.3'
backend_port1 = 40002
backend_weight1 = 1
backend_hostname2 = '192.168.1.4'
backend_port2 = 40003
backend_weight2 = 1
```
> 主机，端口必须根据实际情况设置。

执行：
```
$ echo "postgres:e8a48653851e28c69d0506508fb27fc5" | sudo tee -a /usr/local/etc/pcp.conf

$ echo "host all all all md5" | sudo tee -a /usr/local/etc/pool_hba.conf
```
执行：
```
$ sudo pg_md5 -p -m -u postgres /usr/local/etc/pool_passwd
```
输入`postres`，生成密码。

## 启动

```
$ sudo pgpool -n
```
> 见到`LOG:  pgpool-II successfully started.`字样说明安装成功。

# 参考

https://aijishu.com/a/1060000000131238