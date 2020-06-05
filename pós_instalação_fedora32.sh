#!/usr/bin/env bash
#
# minha_instalacao.sh  -  Pós instalação Fedora 32
#
# Email:        hoffermang@gmail.com         
# Autor:        Hofferman Gabriel
# Manutenção:   Hofferman Gabriel
#
#--------------------DESCRIÇÃO DO SCRIPT------------------------------------------------
#   Faz a instalação dos programas e as atualizações 
#   necessárias no fedora 32 GNOME
#
#--------------------HISTÓRICO----------------------------------------------------------
#   V1- 04/06/2020 - Hofferman Gabriel
#
#--------------------TESTADO EM:--------------------------------------------------------
#  zsh 5.8
#
#--------------------AGRADECIMENTOS:----------------------------------------------------
#   Ao fofo do @joao.igm que ajudou na parte de instalação dos programas
#   
#   Toda a parte do onedrive esta separadamente no https://github.com/abraunegg/onedrive,
#   juntamente com seus créditos 
#
#----------------------TESTES-----------------------------------------------------------
#VERIFICA SE O SCRIPT ESTA SENDO EXECUTADO COMO ROOT
if [ "$EUID" -ne 0 ]
  then echo "Por favor, execute esse script como root"
  exit
fi
#----------------------------------VARIAVEIS----------------------------------------------

#URL's

URL_GOOGLE_CHROME=("https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm")
URL_VS_CODE=("https://az764295.vo.msecnd.net/stable/5763d909d5f12fe19f215cbfdd29a91c0fa9208a/code-1.45.1-1589445456.el7.x86_64.rpm")
URL_TEAMVIEWER=("https://dl.teamviewer.com/download/linux/version_15x/teamviewer_15.6.7.x86_64.rpm")
URL_ANYDESK=("https://download.anydesk.com/linux/anydesk_5.5.6-1_x86_64.rpm?_ga=2.76421269.1038596523.1591282334-454194706.1590978108")
URL_SIMPLENOTE=("https://github.com/Automattic/simplenote-electron/releases/download/v1.17.0/Simplenote-linux-1.17.0-arm64.rpm")
URL_CHERY_TREE=("https://www.giuspen.com/software/cherrytree-0.39.3-1.noarch.rpm")
URL_WPS_OFFICE=("http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9505/wps-office-11.1.0.9505.XA-1.x86_64.rpm")

#PROGRAMAS INSTALADOS VIA YUM E DEPENDENCIAS
PROGRAMAS_YUM=(
   # winehq-stable
    git
  
)

#PROGRAMAS PARA INSTALAR VIA FLATHUB
PROGRAMAS_FLATPAK=(
    flathub com.spotify.Client
    flathub org.telegram.desktop
    flathub org.videolan.VLC
    flathub org.keepassxc.KeePassXC
    flathub com.discordapp.Discord
    flathub com.github.calo001.fondo
    flathub com.github.alainm23.planner
    flathub us.zoom.Zoom
    flathub com.jvieira.tpt.Metronome
    flathub com.dropbox.Client

)
#REPOSITORIOS
REPO_FLATPAK="dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/32/winehq.repo"
REPO_WINE="dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/32/winehq.repo"


#ONDE OS EXECUTAVEIS .RPM FICAM ARMAZENADOS
DIRETORIO_PARA_DOWNLOAD="$HOME/Downloads/Programas"

#------------------------DEPENDENCIAS-------------------------------------------
    sudo dnf groupinstall 'Development Tools'               #onedrive
    sudo dnf install libcurl-devel                          #onedrive
    sudo dnf install sqlite-devel                           #onedrive
    curl -fsS https://dlang.org/install.sh | bash -s dmd    #onedrive



#------------------------EXECUÇÃO-----------------------------------------------

sudo yum update -y

# Instalar programas pelo yum
for apk in $PROGRAMAS_YUM;
do
    [ ! -x $(which $apk) ]; yum install $apk -y

done

#Baixar os programas 
mkdir $DIRETORIO_PARA_DOWNLOAD

wget $URL_ANYDESK               -P "$DIRETORIO_PARA_DOWNLOAD"
wget $URL_CHERY_TREE            -P "$DIRETORIO_PARA_DOWNLOAD"
wget $URL_GOOGLE_CHROME         -P "$DIRETORIO_PARA_DOWNLOAD"
wget $URL_SIMPLENOTE            -P "$DIRETORIO_PARA_DOWNLOAD"
wget $URL_TEAMVIEWER            -P "$DIRETORIO_PARA_DOWNLOAD"
wget $URL_VS_CODE               -P "$DIRETORIO_PARA_DOWNLOAD"
wget $URL_WPS_OFFICE            -P "$DIRETORIO_PARA_DOWNLOAD"


#instalar os programas
sudo rpm -i $DIRETORIO_DOWNLOADS/*.rpm

#Instalar programas flatpak
flatpak install $PROGRAMAS_FLATPAK



#Instalar Onedrive 
git clone https://github.com/abraunegg/onedrive.git
cd onedrive ;
./configure
make clean; make;
sudo make install

