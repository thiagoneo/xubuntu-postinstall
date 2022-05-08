#!/usr/bin/env bash

set -e

# ------------------------------- VARIÁVEIS -----------------------------------#
SCR_DIRECTORY=`pwd`

#------------------ DESATIVAR SUDO TIMEOUT TEMPORARIAMENTE --------------------#
sudo echo ""
while :; do sudo -v; sleep 59; done &
infiloop=$!

#------------------------- APLICAR ATUALIZAÇÕES -------------------------------#
echo ""
echo "INICIANDO ATUALIZAÇÃO COMPLETA DO SISTEMA..."
echo ""
sudo apt update
sudo apt upgrade -y



#---------------------- INSTALAR PACOTES DO LOCAIS ----------------------------#



#--------------------- ADICIONAR REPOSITÓRIO DO DEBIAN ------------------------#
cd $SCR_DIRECTORY/packages
sudo dpkg -i debian-archive-keyring*.deb
sudo chown -R root:root $SCR_DIRECTORY/system-files/
cd $SCR_DIRECTORY/
sudo \cp -rf $SCR_DIRECTORY/system-files/etc/apt/ /etc/
sudo apt update

#---------------------- REMOVER SNAP COMPLETAMENTE ----------------------------#
sudo snap remove firefox gnome-3-38-2004 gtk-common-themes
sudo snap remove bare core20
sudo snap remove snapd
sudo apt purge firefox* chromium* snapd
sudo apt autoremove --purge -y

#--------------------- INSTALAR PACOTES DO REPOSITÓRIO ------------------------#
echo ""
echo "INSTALANDO PACOTES DO REPOSITÓRIO..."
echo ""
sudo apt install $(cat $SCR_DIRECTORY/pacotes-sem-recommends.txt) --no-install-recommends -y
sudo apt install $(cat $SCR_DIRECTORY/pacotes.txt) -y

#--------------------- CONFIGURAR ARQUIVOS DO SISTEMA -------------------------#




#-------------------------- CONFIGURAÇÃO DO USUÁRIO ---------------------------#
#sudo cp -rp /etc/skel/.config/ /etc/skel/.local/ $HOME/ 
#sudo chown -R $USER:$USER $HOME/.config $HOME/.local


#------------------------------------ FIM -------------------------------------#
kill "$infiloop"
clear
echo "Chegamos ao fim."
echo "Você pode reiniciar agora com o comando '/sbin/reboot'."
