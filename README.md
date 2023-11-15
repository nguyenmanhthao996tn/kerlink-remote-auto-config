# Kerlink Gateway Remote Configuration

This repository contains the source code & scripts for updating Semtech UDP Packet Forwarder JSON configuration on Kerlink iBTS Gateway (LR-FHSS).

<p align="center">
  <img src="docs/gateway.jpg" width=300>
</p>

# Before install

Before install this source code on your gateway, you need to prepare the static URL an **index.txt** file and **config.json** on the Internet or your network where the Gateway can access. The template of **index.txt** file is available in [docs/index_template.txt](docs/index_template.txt)

The **index.txt** file contains information needed for an update. You can manage multiple gateways in a single **index.txt** file. Each line contains a gateway information seperated by a space and listed as following:

- **Gateway EUI**: This field have to match the EUI in setup.sh file when you install this reposistory in the later step. This serves the filtering purpose only. No need to match the EUI inside your updating config.json or your network server.
- **Update Patch ID**: A random number. If this number is differ than the number store on the gateway, the update will be triggered.
- **URL to the update**: The URL that the gateway can download the new config.json.

# How to install

1. Download this reposistory into your gateway

```
curl https://codeload.github.com/nguyenmanhthao996tn/kerlink-remote-auto-config/tar.gz/refs/tags/v1.0.0 -o /tmp/kerlink-remote-auto-config-1.0.0.tar.gz
```

2. Extract the archive

```
tar -xvzf /tmp/kerlink-remote-auto-config-1.0.0.tar.gz -C /tmp/
```

3. Modify the ```GATEWAY_EUI``` & ```REMOTE_UPDATE_INDEX_PATH``` in **setup.sh** file to match your requirement

```
cd /tmp/kerlink-remote-auto-config-1.0.0/ && vim setup.sh
```

4. Run the **setup.sh** file

```
./setup.sh
```

5. Go to Monit WebUI <i>(http on port 2812)</i> or use the following command for the health of **remote_auto_config** process
```
monit status
```

# To-do

- [ ] Add encryption for the JSON configuration

---
##### *GLHF!*
