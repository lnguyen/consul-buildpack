#!/bin/sh

$HOME/.consul/consul agent -data-dir $HOME/.consul/data \
   -client $CF_INSTANCE_IP -join 10.10.8.6 \
   -bind=0.0.0.0 \
  > $HOME/.consul/log/consul.log &
