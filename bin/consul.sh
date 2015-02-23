#!/bin/sh

$HOME/.consul/consul agent -data-dir $HOME/.consul/data \
   -client 0.0.0.0 -join 10.10.8.6 \
   -bind=0.0.0.0 -advertise $CF_INSTANCE_IP\
  > $HOME/.consul/log/consul.log &
