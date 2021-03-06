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

downloadReindexScript() {
    echo && echo -e '${GREEN}[1/2]${NONE} Downloading auto reindex script'
    cd
    rm reindex.sh > /dev/null 2>&1
    wget https://raw.githubusercontent.com/nihilocoin/resources/master/scripts/reindex.sh
    sudo chmod 755 reindex.sh
    echo -e "${GREEN}* Done${NONE}";
}

setupCronTab() {
    rm newcron > /dev/null 2>&1
    echo && echo -e '${GREEN}[2/2]${NONE} Setting up new cron'
    echo  "* * * * * cd ~/.nihilocore/sentinel && ./venv/bin/python bin/sentinel.py >> ~/sentinel.log 2>&1" >> newcron
    echo  "*/5 * * * * cd ~/ && bash reindex.sh >> ~/reindex.log 2>&1" >> newcron
    crontab newcron
    rm newcron > /dev/null 2>&1
    echo -e "${GREEN}* Done${NONE}";
}

echo -e "${BOLD}"
read -p "This script will install an auto reindexing script that will check if your wallets block heigh matches the explorer block height. Do you wish to continue? (y/n)?" response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    downloadReindexScript
    setupCronTab
    
    echo && echo -e "${BOLD}Auto reindexing script and cron was installed successfully.${NONE}".
else
    echo && echo "Installation cancelled" && echo
fi
