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
cd $SCR_DIRECTORY
ls $SCR_DIRECTORY/packages/*.deb > pacotes-locais.txt
sudo apt install $(cat $SCR_DIRECTORY/pacotes-locais.txt) --no-install-recommends -y


#------------------ CONFIGURAÇÃO DO GERENCIADOR DE PACOTES --------------------#
cd $SCR_DIRECTORY/packages
sudo dpkg -i linuxmint-keyring*.deb
sudo chown -R root:root $SCR_DIRECTORY/system-files/
cd $SCR_DIRECTORY/
sudo \cp -rf $SCR_DIRECTORY/system-files/etc/apt/ /etc/
sudo apt update


#------------------------ INSTALAR CHROME E ANYDESK ---------------------------#
cd $SCR_DIRECTORY/packages
wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list
sudo apt update
sudo apt install anydesk


#---------------------- REMOVER SNAP COMPLETAMENTE ----------------------------#
sudo snap remove firefox gnome-3-38-2004 gtk-common-themes
sudo snap remove bare core20
sudo snap remove snapd
sudo apt purge firefox* chromium* snapd -y
sudo apt autoremove --purge -y


#------------------- DESINSTALAR PACOTES DESNECESSÁRIOS -----------------------#
sudo apt purge $(cat $SCR_DIRECTORY/lista-remocao.txt) -y
sudo apt autoremove --purge -y


#--------------------- INSTALAR PACOTES DO REPOSITÓRIO ------------------------#
echo ""
echo "INSTALANDO PACOTES DO REPOSITÓRIO..."
echo ""
sudo apt install $(cat $SCR_DIRECTORY/pacotes.txt) -y
sudo apt install $(cat $SCR_DIRECTORY/pacotes-sem-recommends.txt) --no-install-recommends -y


#------------------ CONFIGURAR ARQUIVOS DIVERSOS DO SISTEMA -------------------#
cd $HOME
sudo chown -R root:root $SCR_DIRECTORY/system-files/
cd $SCR_DIRECTORY/
sudo \cp -rf $SCR_DIRECTORY/system-files/etc/lightdm/ /etc/
sudo \cp $SCR_DIRECTORY/system-files/etc/default/grub /etc/default/grub
sudo rm /usr/share/icons/default/index.theme
sudo cp $SCR_DIRECTORY/system-files/usr/share/icons/default/index.theme /usr/share/icons/default/
echo "vm.swappiness=25" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_background_ratio=5" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_ratio=10" | sudo tee -a /etc/sysctl.conf
echo lz4hc | sudo tee -a /etc/initramfs-tools/modules
echo lz4hc_compress | sudo tee -a /etc/initramfs-tools/modules
echo z3fold | sudo tee -a /etc/initramfs-tools/modules
sudo update-initramfs -u
sudo update-grub
sudo ufw enable


#-------------------------- CONFIGURAÇÃO DO USUÁRIO ---------------------------#
sudo cp -rp /etc/skel/.config/ /etc/skel/.local/ $HOME/ 
sudo chown -R $USER:$USER $HOME/.config $HOME/.local


#---------------------------- INSTALAÇÃO DE TEMAS -----------------------------#
#### Matcha GTK Theme ###
cd $SCR_DIRECTORY/
git clone https://github.com/vinceliuice/Matcha-gtk-theme.git
cd Matcha-gtk-theme/
sudo ./install.sh
cd /usr/share/themes/
sudo tar -xzvf $SCR_DIRECTORY/matcha-theme-patch.tar.gz

### Qogir icon theme ###
cd $SCR_DIRECTORY/
git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd Qogir-icon-theme/
sudo ./install.sh


#------------------------------------ FIM -------------------------------------#
kill "$infiloop"
clear
echo "Chegamos ao fim."
echo "Você pode reiniciar agora com o comando '/sbin/reboot'."
