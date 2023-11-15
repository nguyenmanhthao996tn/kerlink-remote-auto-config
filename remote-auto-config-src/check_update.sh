#!/bin/bash

remote_index_path=$(<remote_index_path.txt)

# ===== Functions =====

do_update() {
	# Say hello
	echo "do_update(): NOT IMPLEMENTED"

	# Create new Symbolic Link
	cp -v -f config.json /user/gateway_v2_hal/cfg/remote_config.json
	ln -s -v -f /user/gateway_v2_hal/cfg/remote_config.json /user/gateway_v2_hal/config.json

	# Restart lora_lrfhss service to apply the new config
	monit restart lora_lrfhss
}

# =====================

# Clean previous file run
rm -r -f -v config.json encoded_config.bin

# Script start, say hello
echo "Global JSON Config Auto Update"

# Get the current update patch
local_patch_id=$(<local_patch_id.txt)
echo "Local patch ID: $local_patch_id"

# Get this Gateway EUI
local_gw_eui=$(<gw_eui.txt)
echo "Local gateway EUI: $local_gw_eui"

# Pull the update information file with Gateway EUI filter
remote_update_file=$(curl -s $remote_index_path | grep $local_gw_eui)

# Check if pulling OK
if [ $? -eq 0 ]
then
	echo "Pull update information: $remote_update_file"

	remote_update_params=($remote_update_file) # [0]: Gateway EUI, [1]: Patch ID, [2]: Patch URL
	new_patch_id=${remote_update_params[1]}
	new_patch_url=${remote_update_params[2]}
	echo "Remote index: $new_patch_id"
	echo "Update URL: $new_patch_url"

	if [ $local_patch_id != $new_patch_id ]
	then
		echo "New index detected, update now!"

		# Pull the new config
		curl -f -s $new_patch_url -o config.json

		if [ $? -eq 0 ]
		then
			echo "Pulling new gateway JSON config DONE"

			# Update new_patch_id to local_patch_id
			echo $new_patch_id > local_patch_id.txt

			do_update
		fi
	else
		echo "Same patch id detected, ignore the update"
	fi
else
	echo "Fail to get remote index"
fi

exit 0
