# [:arrow_backward:](../README.md) Nihilo Utilities
What is **Nihilo Utilities** you say? It's a script that we will install globally wich lends us some useful shortcuts for common commands we run on our **Linux VPS** masternode.

## Table of contents
- **[Installation](#installation)**
- **[Usage](#usage)**
	- **[Show wallet info](#show-wallet-info)**
	- **[Show wallet sync status](#show-wallet-sync-status)**
	- **[Masternode status](#masternode-status)**
	- **[Reindex wallet](#reindex-wallet)**
	- **[Edit wallet config](#edit-wallet-config)**
	- **[View sentinel log file](#view-sentinel-log-file)**
	- **[Run sentinel test](#run-sentinel-test)**
	- **[Start wallet daemon](#start-wallet-daemon)**
	- **[Stop wallet daemon](#stop-wallet-daemon)**

## Installation
In order to install **Nihilo Utilities** and be able to use is from any location we need to type the following commands:

````bash
sudo cd /usr/bin
wget 'https://raw.githubusercontent.com/nihilocoin/resources/master/scripts/nihilo-utilities.sh'
sudo mv nihilo-utilities.sh nihilo
sudo chmod 755 nihilo
````

## Usage
To start **Nihilo Utilities** just type **``nihilo``** anywhere on your **Linux VPS** and the following options will be displayed:

## Show wallet info
Will show the wallet daemon info and replaces the following command:

````bash
nihilo-cli getinfo
````

## Show wallet sync status
Shows wallet sync status and replaces the follwing command:

````bash
nihilo-cli mnsync status
````

## Masternode status
Shows masternode status and replaces the following command:

````bash
nihilo-cli masternode status
````

## Reindex wallet
Maybe sometimes the wallet gets stuck and you need to reindex it. This will do exactly this and replaces the following commands:

````bash
nihilo-cli stop
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

## Edit wallet config
Open **``nihilo.conf``** with nano and replaces the following command:

````bash
sudo nano ~/.nihilocore/nihilo.conf
````

## View sentinel log file
Open **sentinel** cron log with nano and replaces the following command:

````bash
sudo nano ~/sentinel.log
````

## Run sentinel test
Runs the sentinel tests and replaces the following command:

````bash
cd ~/.nihilocore/sentinel && ./venv/bin/py.test ./test
````

## Start wallet daemon
Starts the wallet daemon and replaces the following command:

````bash
nihilod -daemon
````

## Stop wallet daemon
Stops the wallet daemon and replaces the following command:

````bash
nihilo-cli stop
````

