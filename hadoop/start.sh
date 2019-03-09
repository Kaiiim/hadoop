#!/bin/bash


/etc/init.d/ssh restart

ssh localhost

echo "yes"

cd /usr/local/hadoop/sbin

sh start-all.sh
