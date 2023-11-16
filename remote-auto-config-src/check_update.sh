#!/bin/bash

remote_index_path="https://rfthings.github.io/GatewayManagement/index.txt"


# ===== Functions =====

do_update() {
	# Say hello
	echo "Start updating procedure..."

	# Create new Symbolic Link
	echo "Copying new json.config to gateway_v2_hal folder"
	cp -v -f config.json /user/gateway_v2_hal/cfg/remote_config.json
	echo "Creating symbolic link for new config.json"
	ln -s -v -f /user/gateway_v2_hal/cfg/remote_config.json /user/gateway_v2_hal/config.json

	# Restart lora_lrfhss service to apply the new config
	echo "Restarting monit service"
	monit restart lora_lrfhss

	echo "Update DONE"
}

# =====================

# Get the current location
current_path='/user/remote_auto_config'
echo "Current directory = $current_path"

# Clean previous file run
rm -r -f -v ${current_path}/config.json ${current_path}/encoded_config.bin

# Script start, say hello
echo "Global JSON Config Auto Update"

# Get the current update patch
local_patch_id=$(<${current_path}/local_patch_id.txt)
echo "Local patch ID: $local_patch_id"

# Get this Gateway EUI
local_gw_eui=$(<${current_path}/gw_eui.txt)
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
			
			# Get new JSON config MD5
			md5=$(md5sum config.json | awk '{ print $1 }')
			echo "Patch MD5: $md5"
			if [ $md5 = $new_patch_id ]
			then
				# Update new_patch_id to local_patch_id
				echo $new_patch_id > ${current_path}/local_patch_id.txt

				do_update
			else
				echo "MD5 mismatch detected, try again later"
				echo "MD5 from index.txt: $new_patch_id"
				echo "MD5 calculated: $md5"
			fi
		fi
	else
		echo "Same patch id detected, ignore the update"
	fi
else
	echo "Fail to get remote index"
fi

exit 0
