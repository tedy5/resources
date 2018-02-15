#bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

#Shut down wallet daemon
echo && echo 'Shuting down wallet daemon'
nihilo-cli stop > /dev/null 2>&1
sleep 5
echo -e "${GREEN}* Done${NONE}";

ufw allow 11998/tcp

#Replace port
echo && echo 'Replacing port'
cd ~/.nihilocore
rpl 13534 11998 nihilo.conf
echo -e "${GREEN}* Done${NONE}";

#remove old sentinel
echo && echo 'Removing old sentinel'
sudo rm -rf sentinel
echo -e "${GREEN}* Done${NONE}";

#install new sentinel
echo && echo 'Installing new sentinel'
git clone https://github.com/nihilocoin/sentinel sentinel
cd sentinel
export LC_ALL=C
virtualenv ./venv
./venv/bin/pip install -r requirements.txt

CONFLOCATION=$(cd ~/.nihilocore && pwd)
rpl dash_conf=/home/YOURUSERNAME/.nihilocore/nihilo.conf dash_conf=$CONFLOCATION/.nihilo.conf sentinel.conf
cd && rm sentinel.log
echo -e "${GREEN}* Done${NONE}";

#Reindexing wallet
echo && echo 'Reindexing wallet'
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
echo -e "${GREEN}* Done${NONE}";

#starting wallet
echo && echo 'Starting wallet daemon...'
nihilod -daemon > /dev/null 2>&1
sleep 5
echo -e "${GREEN}* Done${NONE}";
echo 'Waiting for wallet to sync. It will take a while, you can go grab a coffee :)'
until nihilo-cli mnsync status | grep -m 1 '"IsBlockchainSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Blockchain Synced${NONE}";
until nihilo-cli mnsync status | grep -m 1 '"IsMasternodeListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Masternode List Synced${NONE}";
until nihilo-cli mnsync status | grep -m 1 '"IsWinnersListSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Winners List Synced${NONE}";
until nihilo-cli mnsync status | grep -m 1 '"IsSynced": true'; do sleep 1 ; done > /dev/null 2>&1
echo -e "${GREEN}* Done reindexing wallet${NONE}";

echo && echo 'Testing new sentinel installation...'
cd ~/.nihilocore/sentinel
./venv/bin/py.test ./test
cd
echo -e "${GREEN}* Done${NONE}";
echo
