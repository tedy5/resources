#!/bin/bash
#

# tool paths
cli='nihilo-cli'
daemon='nihilod'

# data dir
data="~/.nihilocore"

# api url
api_url='http://172.104.246.158/api/getblockcount'

# check if already reindex process is still active
if ! $cli mnsync status | grep -m 1 '"AssetID": 999'; then
    exit 1
fi

# get local and remote block count
api_blocks=$(curl -s ${api_url})
local_blocks=$(${cli} getblockcount)

# reindex if api blocks > local wallet blocks
if (( api_blocks > local_blocks )); then
        ${cli} stop
        sleep 0.5
        rm -rf ${data}/{governance.dat,netfulfilled.dat,peers.dat,blocks,mncache.dat,chainstate,fee_estimates.dat,mnpayments.dat,banlist.dat}
        sleep 1
        ${daemon} -daemon -reindex
        exit 1
else
        exit 0
fi