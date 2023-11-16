#!/bin/bash

GATEWAY_EUI="7276ff000f061f15"
REMOTE_UPDATE_INDEX_PATH="https://rfthings.github.io/GatewayManagement/index.txt"

# Remote auto config
echo "Copying remote_auto_config resources to /user/..."
mkdir -p /user/remote_auto_config/log/
cp -v -f ./remote-auto-config-src/* /user/remote_auto_config/

echo "Creating gw_eui.txt, remote_index_path.txt, local_patch_id.txt"
echo $GATEWAY_EUI > /user/remote_auto_config/gw_eui.txt
echo $REMOTE_UPDATE_INDEX_PATH > /user/remote_auto_config/remote_index_path.txt
echo 0 > /user/remote_auto_config/local_patch_id.txt

# Monit
echo "Copying monit resources..."
cp -v -f ./monit-scripts/remote_auto_config /etc/monit.d/remote_auto_config
cp -v -f ./monit-scripts/start_remote_auto_config /etc/init.d/start_remote_auto_config
cp -v -f ./monit-scripts/stop_remote_auto_config /etc/init.d/stop_remote_auto_config

echo "Updating permission..."
chmod +x /etc/init.d/start_remote_auto_config
chmod +x /etc/init.d/stop_remote_auto_config
chmod +x /user/remote_auto_config/*.sh

monit reload

exit 0