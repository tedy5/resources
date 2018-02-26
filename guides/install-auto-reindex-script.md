## Auto Reindex Script
This script will check every 5 minutes the block of the official explorer and compare it to your masternode block height. If the masternode block height is smaller than the explorer block heigh, it will automatically reindex your wallet. 

Keep in mind that is still in testing, but from testing there were good results so far.

This script will work as it is for people who used the **``easy install script``** for installing their masternode.

## Installation
In order to install it you need to login into your **VPS** using **putty** or whatever **SSH** client you are using and type the following commands one by one.

````bash
wget https://raw.githubusercontent.com/nihilocoin/resources/master/scripts/install_auto_reindex.sh
bash install_auto_reindex.sh
````

## What does the install script do?
1. It will download the **[reindex script](https://github.com/nihilocoin/resources/blob/master/scripts/reindex.sh)** from **[here](https://github.com/nihilocoin/resources/blob/master/scripts/reindex.sh)** and give it the required permisions.
2. It will add the script in your crontab and run it every 5 minutes.

## Contribution
If you think something can be done differently and/or better please submit a **PR** so we all can make it better.
