#!/bin/bash

echo "Remote auto config for Kerlink iBTS Gateway (LR-FHSS)"

while true
do
	/user/remote-auto-config/check_update.sh
	sleep 60 # Check every minute
done
exit 0
