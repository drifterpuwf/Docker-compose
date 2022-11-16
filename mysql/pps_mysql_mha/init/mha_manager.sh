#!/bin/bash

# # 检查容器间的 SSH
masterha_check_ssh  --conf=/etc/mha/mha_manager.cnf

# # 检查 MySQL 的主从复制
masterha_check_repl --conf=/etc/mha/mha_manager.cnf

# 启动 manager
masterha_manager --conf=/etc/mha/mha_manager.cnf  --remove_dead_master_conf --ignore_last_failover