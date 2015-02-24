#!/bin/sh

jq=$HOME/.consul/jq

server_rpc=$(echo $VCAP_APPLICATION | $jq .extra_ports.server_rpc.host_port)
serf_lan=$(echo $VCAP_APPLICATION | $jq .extra_ports.serf_lan.host_port)
serf_wan=$(echo $VCAP_APPLICATION | $jq .extra_ports.serf_wan.host_port)
cli_rpc=$(echo $VCAP_APPLICATION | $jq .extra_ports.cli_rpc.host_port)
http_api=$(echo $VCAP_APPLICATION | $jq .extra_ports.http_api.host_port)
dns_interface=$(echo $VCAP_APPLICATION | $jq .extra_ports.dns_interface.host_port)
node_name=$(echo $VCAP_APPLICATION | $jq -r .application_name)-$CF_INSTANCE_INDEX

cat <<EOF > $HOME/.consul/agent.json
{
  "data_dir": "$HOME/.consul/data",
  "node_name": "${node_name}",
  "bind_addr": "0.0.0.0",
  "client_addr": "0.0.0.0",
  "advertise_addr": "${CF_INSTANCE_IP}",
  "domain": "consul",
  "leave_on_terminate": false,
  "log_level": "INFO",
  "server": false,
  "rejoin_after_leave": true,
  "start_join": [
    "10.10.8.6",
    "10.10.8.7",
    "10.10.8.8"
  ],
  "ports": {
    "dns": ${dns_interface},
    "http": ${http_api},
    "rpc": ${cli_rpc},
    "serf_lan": ${serf_lan},
    "serf_wan": ${serf_wan},
    "server": ${server_rpc}
  }
}
EOF

$HOME/.consul/consul agent -config-file $HOME/.consul/agent.json \
  > $HOME/.consul/log/consul.log &
