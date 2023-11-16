#!/bin/bash

echo "INFO: Remote auto config for Kerlink iBTS Gateway (LR-FHSS)"

while true
do
	echo "INFO: Trigger checking update..."
	/user/remote_auto_config/check_update.sh
	sleep 60 # Check every minute
done
exit 0
