# Upgrade Masternode Wallet to version 1.0.2

This guide will show you how you can update your wallet to version 1.0.2. This update is not mandatory if you are not having problems with your masternode. **This version is madatory for pool operators only**.

## Installation

Log into your vps and type the following commands:

````bash
wget https://raw.githubusercontent.com/nihilocoin/resources/master/scripts/upgrade_wallet_to_1_0_2.sh
sudo chmod 755 upgrade_wallet_to_1_0_2.sh
sudo bash upgrade_wallet_to_1_0_2.sh
````

Now the last step will also reindex your wallet so it might take a few minutes. If you're masternode was in **``NEW_START_REQUIRED``** status before upgrading you need to click **``Start Alias``** from you're cold wallet in order to start it again.

Upgraded **GUI Wallets** for other platforms can be found **[here](https://github.com/nihilocoin/nihilo/releases/tag/1.0.2)**.
