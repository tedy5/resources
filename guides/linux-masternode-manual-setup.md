# [:arrow_backward:](./masternode-windows-cold-wallet-with-linux-vps.md) Linux Masternode Manual Setup
This is not a complete guide, this guide is for those who don't want to use the **[easy install script](./masternode-windows-cold-wallet-with-linux-vps.md#easy-install-script)** and want to setup the **masternode** the old fashioned way.

We still recommend that you use the **[easy install script](./masternode-windows-cold-wallet-with-linux-vps.md#easy-install-script)** because it's faster with it.

## Table of contents
- **[Setup swap space](#setup-swap-space)**
- **[Update and upgrade](#update-and-upgrade)**
- **[Basic Intrusion Prevention with Fail2Ban](#basic-intrusion-prevention-with-fail2ban)**
- **[Set Up a Basic Firewall](#set-up-a-basic-firewall)**
- **[Install required dependencies](#install-required-dependencies)**
- **[Install the wallet](#install-the-wallet)**
- **[Install Nihilo Utilities](#install-nihilo-utilities)**
- **[Configure the wallet](#configure-the-wallet)**
- **[Start the wallet](#start-the-wallet)**
- **[Install sentinel](#install-sentinel)**
- **[Getting masternode config for windows wallet](#getting-masternode-config-for-windows-wallet)**

## Setup swap space
This is our first step, i know **swap space** is slow, but for a **VPS** with only **1GB of ram** it's mandatory. Log into the **VPS** as root and start typing the following commands:

````bash
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
````

Now that the swap is created, let's make it work better

````bash
sudo nano /etc/sysctl.conf
````

Add to the bottom of the file

````
vm.swappiness=10
vm.vfs_cache_pressure=50	
````

Also let's make sure the swap if mounted again after a server restart

````bash
sudo nano /etc/fstab
````

Add to the bottom of the file

````
/swapfile   none    swap    sw    0   0
````

## Update and upgrade
Now let's run **update** and **upgrade** by typing the following commands:

````bash
sudo apt-get -y update
sudo apt-get -y upgrade
````

You will be asked to choose an option when upgrading, leave the default one that is selected and just hit **``Enter``**.

## Basic Intrusion Prevention with Fail2Ban
We will add a basic **dictionary attack** protection. This will ban an IP address for 10 minutes after 10 failed login attempts.

````bash
sudo apt-get -y install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
````

If you want to see what **Fail2Ban** is doing behing the scenes just type the following command. You can exit with **``CTRL+C``**.

````bash
sudo tail -f /var/log/fail2ban.log
````

## Set Up a Basic Firewall
**Ubuntu 16.04** can use the **UFW Firewall** to make sure only connections to certain services are allowed. We can set up a basic firewall very easily using this application.

````bash
sudo ufw allow OpenSSH
sudo ufw allow 11998/tcp
sudo ufw allow 13535/tcp
sudo ufw enable
````

You will be asked if you want to enable it, type **``Y``**. If you want to see the status of the **firewall** type the following command:

````bash
sudo ufw status
````

## Install required dependencies
In order to build the wallet, we need to install the following dependencies:

````bash
sudo apt-get -y install git nano rpl wget python-virtualenv build-essential libtool automake autoconf autotools-dev autoconf pkg-config libssl-dev libgmp3-dev libevent-dev bsdmainutils libboost-all-dev software-properties-common python-software-properties virtualenv
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get -y update
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libzmq5
````	

## Install the wallet
Now we need to clone the **coin source** from **github** and build the wallet. Type the following commands to do so:

````bash
cd
git clone https://github.com/nihilocoin/nihilo nihilo
cd nihilo
chmod 755 autogen.sh
sudo ./autogen.sh
sudo ./configure
chmod 755 share/genbuild.sh
sudo make
````

Now grab a coffee :coffee: or whatever beverage you preffer and wait for the wallet to finish compiling.

After the compilation is done, let's make the wallet so we can access it from any location.

````bash
cd
cd nihilo/src
strip nihilod
strip nihilo-cli
strip nihilo-tx
sudo mv nihilod /usr/bin
sudo mv nihilo-cli /usr/bin
sudo mv nihilo-tx /usr/bin
cd && sudo rm -rf nihilo
````

## Install Nihilo Utilities
This is optional but could be useful since it offers some shortcuts to common commands that you will use. You can learn more about it **[here](./nihilo-utilities.md)** and you can install it by typing the following commands:

````bash
cd /usr/bin
wget 'https://raw.githubusercontent.com/nihilocoin/resources/master/scripts/nihilo-utilities.sh'
sudo mv nihilo-utilities.sh nihilo
sudo chmod 755 nihilo
````

You can now access it by typing **``nihilo``** anywhere on the server.


## Configure the wallet
Let's configure the wallet now, we'll start by **starting the wallet daemon for 10 seconds and then closing it again**. We are doing this so the wallet can dump it's core.

````bash
nihilod -daemon
#wait 10 seconds
nihilo-cli stop
````

Now lets configure the **``nihilo.conf``** configuration files. The file is located in **``~/.nihilocore``** but we will use the following commands to add the required config.

````bash
cd
mnip=$(curl ipinfo.io/ip)
rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
rpcpass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
mnkey=$(nihilo-cli masternode genkey)
echo -e "rpcuser=${rpcuser}\nrpcpassword=${rpcpass}\nrpcport=11998\nrpcallowip=127.0.0.1\nrpcthreads=8\nlisten=1\nserver=1\ndaemon=1\nstaking=0\ndiscover=1\nexternalip=${mnip}:13535\nmasternode=1\nmasternodeprivkey=${mnkey}" > ~/.nihilocore/nihilo.conf
````

## Install sentinel
**TL;DR** Sentinel is a **watch dog** for our masternodes that reports the status of your masternode. Let's start:

````bash
cd
cd .nihilocore
git clone https://github.com/nihilocoin/sentinel sentinel
cd sentinel
export LC_ALL=C
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
````

Now let's change it's config a little.

````bash
sudo nano sentinel.conf
````

Make sure here that **``dash_conf``** doesn't have an **``#``** at the begining and check if the path of your **``nihilo.conf``** configuration file is ok. You can check your path by going to ``cd ~/.nihilocore`` and typing ``pwd``. Close the file and run the following command to test that everything is ok with sentinel:

````bash
./venv/bin/py.test ./test
````

You should get **green** now. One last step is to add sentinel to our crontab so it will periodically send the status of the masternode.

````bash
echo  "* * * * * cd ~/.nihilocore/sentinel && ./venv/bin/python bin/sentinel.py >> ~/sentinel.log 2>&1" >> mycron
crontab mycron
rm mycron
````

## Start the wallet
We can now start the wallet and let it fully sync.

````bash
cd ~/.nihilocore
sudo rm governance.dat
sudo rm netfulfilled.dat
sudo rm peers.dat
sudo rm -r blocks
sudo rm mncache.dat
sudo rm -r chainstate
sudo rm fee_estimates.dat
sudo rm mnpayments.dat
sudo rm banlist.dat
cd
nihilod -daemon
````

Check the status by running the following command and wait till you see **``"IsSynced": true``** then exit by typing **``CTRL+C``**.

````bash
watch nihilo-cli mnsync status
````

## Getting masternode config for windows wallet
:white_check_mark: **Great**, now everything is ready on our **Linux VPS**, type the following command to receive the line that you will need in order to finish the **Windows** part.

````bash
echo "masternode1 ${mnip}:12875 ${mnkey} tx index"
````

**Save** this line somewhere on your pc and continue with the **[Windows part of the setup here](./masternode-windows-cold-wallet-with-linux-vps.md#windows-setup)**.
