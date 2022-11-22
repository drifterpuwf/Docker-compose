#!/bin/sh

if [ "$1" = 'redis-cluster' ]; then
    sleep 10
    echo "yes" | ruby /redis/src/redis-trib.rb create --replicas  0.0.0.0:7000 0.0.0.0:7001 0.0.0.0:7002 0.0.0.0:7003 0.0.0.0:7004 0.0.0.0:7005
    echo "DONE"
else
  exec "$@"
fi

