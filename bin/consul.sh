#!/bin/sh

$HOME/.consul/consul agent -data-dir $HOME/.consul/data \
   -client $CF_INSTANCE_IP -join 10.10.8.6 \
  > $HOME/.consul/log/consol.log &
