#bin/sh
nihilo-cli stop

cd && mkdir new && cd new

wget https://github.com/nihilocoin/nihilo/releases/download/1.0.1/Nihilo_Command_Line_Binaries_Linux_1_0_1.tar.gz
tar -xf Nihilo_Command_Line_Binaries_Linux_1_0_1.tar.gz

cd /usr/bin
sudo rm -rf nihilod nihilo-cli nihilo-tx

cd ~/new
strip nihilod
strip nihilo-cli
strip nihilo-tx
sudo mv nihilod /usr/bin
sudo mv nihilo-cli /usr/bin
sudo mv nihilo-tx /usr/bin

cd && sudo rm -rf new

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
nihilod -daemon -reindex
