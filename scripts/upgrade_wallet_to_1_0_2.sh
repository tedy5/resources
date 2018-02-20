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

shutDownWallet() {
    #Shut down wallet daemon
    echo && echo 'Shuting down wallet daemon'
    nihilo-cli stop > /dev/null 2>&1
    sleep 5
    echo -e "${GREEN}* Done${NONE}";
}

downloadNewWallet() {
    #Download new wallet
    echo && echo 'Downloading new wallet'
    wget https://github.com/nihilocoin/nihilo/releases/download/1.0.2/Nihilo_Command_Line_Binaries_Linux_1_0_2.tar.gz
    tar -xf Nihilo_Command_Line_Binaries_Linux_1_0_1.tar.gz
    echo -e "${GREEN}* Done${NONE}"; 
}

installNewWallet() {
    #Install new wallet
    echo && echo 'Installing new wallet'
    cd /usr/bin
    sudo rm -rf nihilod nihilo-cli nihilo-tx
    cd ~/Nihilo_Command_Line_Binaries_Linux_1_0_1
    sudo mv nihilod nihilo-cli nihilo-tx /usr/bin
}

reindexWallet() {
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
}

startWallet() {
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
}

echo -e "${BOLD}"
read -p "This script will upgrade your Nihilo Wallet to version 1.0.2 . Do you wish to continue? (y/n)?" response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    shutDownWallet
    downloadNewWallet
    installNewWallet
    reindexWallet
    startWallet
    
    echo && echo -e "${BOLD}New wallet was installed successfully. If you had NEW_START_REQUIRED status before running this script, go to your Cold Wallet and click Start Alias, if not then you're good to go!${NONE}".
else
    echo && echo "Installation cancelled" && echo
fi
