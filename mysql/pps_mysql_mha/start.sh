#!/bin/bash
# author:hooray

#################### 变量定义 ####################
MYSQL_ROOT_PASSWORD="root"               # 每台服务器的root密码
MYSQL_REPLICATION_USER="hooray"          # 主服务器允许从服务器登录的用户名
MYSQL_REPLICATION_PASSWORD="hooray"      # 主服务器允许从服务器登录的密码

#################### 环境文件生成 ####################
# 生成mysql.env
echo "# MySQL root 账号密码
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
# 用于 MySQL 集群间同步的账号密码
MYSQL_REPLICATION_USER=${MYSQL_REPLICATION_USER}
MYSQL_REPLICATION_PASSWORD=${MYSQL_REPLICATION_PASSWORD}
" >./env/mysql.env

#################### 配置文件生成 ####################
# 生成mha_manager.cnf文件
echo "[server default]
# mysql用户密码
user=root
password=${MYSQL_ROOT_PASSWORD}
# ssh用户
ssh_user=root

# 工作目录
manager_workdir=/var/log/masterha/
remote_workdir=/var/log/masterha/

# 主从同步账号
repl_user=${MYSQL_REPLICATION_USER}
repl_password=${MYSQL_REPLICATION_PASSWORD}
ping_interval=1

# 各服务参数配置
[server1]
hostname=mysql_master
port=3306
master_binlog_dir=/var/lib/mysql
ignore_fail=1
no_master=1

[server2]
hostname=mysql_slave1
port=3306
master_binlog_dir=/var/lib/mysql
candidate_master=1
check_repl_delay=0

[server3]
hostname=mysql_slave2
port=3306
master_binlog_dir=/var/lib/mysql
candidate_master=1
check_repl_delay=0
" >./conf/mha_manager.cnf

#################### docker-compose初始化 ####################
docker-compose build
docker-compose up -d

#################### 执行挂载好的脚本 ####################
# 生成ssh key
docker exec -it mysql_master /bin/bash /etc/init.d/script/ssh_generate_key.sh
docker exec -it mysql_slave1 /bin/bash /etc/init.d/script/ssh_generate_key.sh
docker exec -it mysql_slave2 /bin/bash /etc/init.d/script/ssh_generate_key.sh
docker exec -it mha_manager /bin/bash /etc/init.d/script/ssh_generate_key.sh
# 授权ssh key
docker exec -it mysql_master /bin/bash /etc/init.d/script/ssh_auth_keys.sh
docker exec -it mysql_slave1 /bin/bash /etc/init.d/script/ssh_auth_keys.sh
docker exec -it mysql_slave2 /bin/bash /etc/init.d/script/ssh_auth_keys.sh
docker exec -it mha_manager /bin/bash /etc/init.d/script/ssh_auth_keys.sh