#!/bin/bash

# 启动ssh服务
service ssh start
# 生成ssh的key
ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa
# 将pub文件拷到容器间共享目录下
cp /root/.ssh/id_rsa.pub "/root/share_sshkeys/id_rsa_${KEY_SUFFIX}.pub"