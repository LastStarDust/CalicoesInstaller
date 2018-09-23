#!/bin/bash

# AnpanInstaller.sh
# Copyright (C) 2018 by Pintaudi Giorgio <giorgio-pintaudi-kx@ynu.jp>
# Released under the GPLv3 license
#
#     Pintaudi Giorgio (PhD Student)
#     Yokohama National University
#     giorgio-pintaudi-kx@ynu.jp
#
# This is a bash script that installs the anpan software based on calicoes 3.0
# http://llr.in2p3.fr/sites/pyrame/calicoes/index.html
# along with all its dependencies for the Ubuntu OS. It is an updated
# and corrected version based on the original installation script for CentOS 7.
# The original script can be found and downloaded here:
# http://llr.in2p3.fr/sites/pyrame/calicoes/disclaimer.html
# Credits for the calicoes software and the original version of this script go to
# Frédéric Magniette and Miguel Rubio-Roy.

set -e

ROOTREP="n"
DIMREP="n"
LEVBDIMREP="n"
LCIOREP="n"
CONTINUE="n"
UBUNTU="n"
CENTOS="n"

# Check the Ubuntu release

if [ "`lsb_release -rs`" != "18.04" ] && [ ! -f "/etc/redhat-release"];
then
    echo "This installer is for Ubuntu 18.04 and CentOS 7 only!"
    echo "You can get this script to run also on other versions of Ubuntu"
    echo "by simply replacing the 18.04 string on line 32 with your Ubuntu"
    echo "version but be warned that other modifications may be needed."
    exit 1
fi

if [ "`lsb_release -rs`" == "18.04" ];
then
    UBUNTU="y"
elif [ -f "/etc/redhat-release"];
then
    CENTOS="y"
else
    echo "There is something wrong about OS detection."
    echo "UBUNTU = $UBUNTU"
    echo "CENTOS = $CENTOS"
    exit 1
fi

#check if sudo has been used

if [ "`whoami`" == "root" ];
then
    echo "This installer is not intended be run as root or with sudo"
    echo "You will need to insert the user password AFTER the script has started."
    exit 1
fi

if [ $CENTOS == "y" ];
then
    # check for selinux

    if [ "`grep -c "SELINUX=disabled" /etc/selinux/config`" != "1" ];
    then
	echo "SElinux is active. This prevents Anpan from working properly."
	echo "This operation will need a reboot. Please relaunch the installer"
	echo "as soon as reboot is completed."
	echo -n "Do you want this installer to fix the problem? (y|n) : "
	read REP
	if [ "${REP}" == "y" ];
	then
	    echo "SELINUX=disabled" > /etc/selinux/config
	    echo "SELINUXTYPE=targeted" >> /etc/selinux/config
	    echo "Please reboot your machine and restart this installer."
	    #reboot
	    exit 1
	else
	    echo "Please deactivate Selinux and try this installer again"
	    exit 1
	fi
    fi
fi

# Check for ROOT
if [ "$ROOTSYS" == "" ];
then
    echo "Root6 is an optional dependency of anpan."
    echo "It seems that it is not installed (looking for a non null ROOTSYS variable)"
    echo "Maybe you have just forgot to set the root enviroment"
    echo "with the script thisroot.sh. In that case please run that script"
    echo "and then restart this installation process."
    echo "Or maybe ROOT is not installed in your system. In that case this script can"
    echo "take care of the ROOT compiling and installation."
    echo "The total compilation of the sources could take up to an hour."
    echo -n "Do you want this installer to install it? (y|n) : "
    read ROOTREP
    if [ "${ROOTREP}" == "n" ];
    then
	echo -n "Do you want this installer to continue anyway? (y|n) : "
	read CONTINUE
	if [ "${CONTINUE}" == "n" ];
	then
	    exit 1
	else
	    CONTINUE = "" 
	fi
    elif [ "${ROOTREP}" == "y" ];
    then
	echo -n "Set to install it (ROOTREP=\"y\")"
    else
	echo "I didn't understand your answer. Sorry, try again."
	exit 1
    fi
fi

# Check for DIM
# For the time being it is not used by Anpan
DIMREP="n"
# if [ ! -d "/usr/local/lib/dim" ];
# then
#     echo ""
#     echo ""
#     echo "Dim is an optional dependency of anpan (only for SDHcal compat)."
#     echo "It seems that it is not installed (looking for /usr/local/lib/dim)"
#     echo "The total compilation of the sources should take very little time"
#     echo -n "Do you want this installer to install it? (y|n) : "
#     read DIMREP
#     if [ "${DIMREP}" == "n" ];
#     then
# 	echo -n "Do you want this installer to continue anyway? (y|n) : "
# 	read CONTINUE
# 	if [ "${CONTINUE}" == "n" ];
# 	then
# 	    exit 1
# 	else
# 	    CONTINUE = "" 
# 	fi
#     elif [ "${DIMREP}" == "y" ];
#     then
# 	echo -n "Set to install it (DIMREP=\"y\")"
#     else
# 	echo "I didn't understand your answer. Sorry, try again."
# 	exit 1
#     fi
# fi

# Check for Liblevbdim
# For the time being it is not used by Anpan
LEVBDIMREP="n"
# if [ ! -f "/usr/local/lib/dim/liblevbdim.so" ];
# then
#     echo ""
#     echo ""
#     echo "Levbdim is an optional dependency of anpan (only for SDHcal compat)."
#     echo "It seems that it is not installed (looking for /usr/local/lib/dim/liblevbdim.so)"
#     echo "Be aware that dim is a dependency for levbdim."
#     echo "The total compilation of the sources should take very little time"
#     echo -n "Do you want this installer to install it? (y|n) : "
#     read LEVBDIMREP
#     if [ "${LEVBDIMREP}" == "n" ];
#     then
# 	echo -n "Do you want this installer to continue anyway? (y|n) : "
# 	read CONTINUE
# 	if [ "${CONTINUE}" == "n" ];
# 	then
# 	    exit 1
# 	else
# 	    CONTINUE = "" 
# 	fi
#     elif [ "${LEVBDIMREP}" == "y" ];
#     then
# 	echo -n "Set to install it (DIMREP=\"y\")"
#     else
# 	echo "I didn't understand your answer. Sorry, try again."
# 	exit 1
#     fi
# fi

# Check for LCIO
# For the time being it is not used by Anpan
LCIOREP="n"
# if [ ! -d "/opt/lcio" ];
# then
#     echo ""
#     echo ""
#     echo "LCIO is an optional dependency of anpan."
#     echo "It seems that it is not installed (looking for /opt/lcio)"
#     echo "The total compilation of the sources should some minutes"
#     echo -n "Do you want this installer to install it? (y|n) : "
#     read LCIOREP
#     if [ "${LCIOREP}" == "n" ];
#     then
# 	echo -n "Do you want this installer to continue anyway? (y|n) : "
# 	read CONTINUE
# 	if [ "${CONTINUE}" == "n" ];
# 	then
# 	    exit 1
# 	else
# 	    CONTINUE = "" 
# 	fi
#     elif [ "${LCIOREP}" == "y" ];
#     then
# 	echo -n "Set to install it (DIMREP=\"y\")"
#     else
# 	echo "I didn't understand your answer. Sorry, try again."
# 	exit 1
#     fi
# fi

echo ""
echo "Moving to the HOME directory."
cd

#install mandatory dependencies for pyrame and anpan
if [ $UBUNTU == "y" ];
then
    if [ ! -f /etc/apt/sources.list.d/apache_couchdb_bionic.list ];
    then
	sudo apt-get install curl
	echo "deb https://apache.bintray.com/couchdb-deb bionic main" \
            | sudo tee -a /etc/apt/sources.list.d/apache_couchdb_bionic.list
	curl -L https://couchdb.apache.org/repo/bintray-pubkey.asc \
            | sudo apt-key add -
    fi
    sudo apt update
    sudo apt-get install build-essential python python-devel python-pip psmisc \
	 git libsdl1.2-dev libsdl-ttf2.0-dev elog python-sphinx \
	 libafterimage-dev flex libexpat1-dev liblua5.2-dev \
	 libcurl4 python-progressbar apache2 r-base \
	 couch-libmozjs185-1.0 python-requests libmotif-dev tcsh \
	 libxt-dev curl libboost-dev libboost-system-dev \
	 libboost-filesystem-dev libboost-thread-dev libjsoncpp-dev \
	 libcurl4-gnutls-dev scons libmongoclient-dev libboost-regex-dev
elif [ $CENTOS == "y" ];
then
    if [ ! -f /etc/yum.repos.d/couchdb.repo ];
    then
	sudo tee /etc/yum.repos.d/couchdb.repo << 'EOF'
[bintray--apache-couchdb-rpm]
name=bintray--apache-couchdb-rpm
baseurl=http://apache.bintray.com/couchdb-rpm/el$releasever/$basearch/
gpgcheck=0
repo_gpgcheck=0
enabled=1
EOF
    fi
    sudo yum -y install epel-release
    sudo yum -y update
    sudo yum install make automake gcc gcc-c++ kernel-devel python python-dev \
	 python-pip psmisc git SDL-devel SDL_ttf-devel elog python-sphinx \
	 libAfterImage flex expat-devel lua-devel libcurl python-progressbar \
	 R httpd python-requests motif-devel tcsh libXt-devel curl \
	 curl-devel boost-devel boost-filesystem boost-system boost-thread \
	 boost-regex jsoncpp-devel scons libmongo-client	 
fi

echo ""
echo "Be sure NOT to create a administrator user for couchdb!"
echo "You avoid creating an administrator user by just inserting" 
echo "an EMPTY password."
read -n1 -r -p "Press any key to continue..." key

if [ $UBUNTU == "y" ];
then
    sudo apt-get install couchdb
elif [ $CENTOS == "y" ];
then
    sudo yum install couchdb
fi

pip install --upgrade pyserial notify2 argparse couchdb
# If you want to generate the documentation, install also:
pip install --upgrade docutils Pygments

#install root if necessary
if [ "${ROOTREP}" == "y" ];
then
    echo ""
    echo "-------------------"
    echo "ROOT INSTALLATION"
    echo "-------------------"
    echo "Insert the directory where you want ROOT to be installed."
    echo "Don't insert the trailing slash. For example \"$HOME/Code/ROOT\"."
    echo "This script is not intended to be run as root."
    echo "So please insert a directory that is writable by the current user."
    echo "If you wish to install ROOT in a system directory, please do it manually"
    echo "or just place \"sudo\" in front of every relevant line in this script"
    echo "from line 263 to line 270 (more or less)."
    read ROOTSYS
    if [ -z "$ROOTSYS" ]; then
        mkdir -p ${HOME}/ROOT
        ROOTSYS=${HOME}/ROOT
    fi
    
    if [ $UBUNTU == "y" ];
    then
	sudo apt-get install build-essential git dpkg-dev cmake xutils-dev \
	     binutils libx11-dev libxpm-dev libxft-dev libxext-dev \
	     libssl-dev libpcre3-dev libglu1-mesa-dev libglew-dev \
	     libmysqlclient-dev libfftw3-dev libcfitsio-dev libgraphviz-dev \
	     libavahi-compat-libdnssd-dev libldap2-dev python-dev libxml2-dev \
	     libkrb5-dev libgsl-dev libqt4-dev libmotif-dev libmotif-common \
	     libblas-dev liblapack-dev xfstt xfsprogs t1-xfree86-nonfree \
	     ttf-xfree86-nonfree ttf-xfree86-nonfree-syriac xfonts-75dpi \
	     xfonts-100dpi libgif-dev libtiff-dev libjpeg-dev liblz4-dev \
	     liblzma-dev libgl2ps-dev libpostgresql-ocaml-dev libsqlite3-dev \
	     libpythia8-dev davix-dev srm-ifce-dev libtbb-dev python-numpy
	cd
    elif [ $CENTOS == "y" ];
    then
	sudo yum install make automake gcc gcc-c++ kernel-devel git cmake \
	     xorg-x11-util-macros binutils libX11-devel libXft-devel openssl-devel \
	     pcre2-devel mesa-libGLU-devel glew-devel avahi-compat-libdns_sd-devel \
	     mariadb-devel fftw-devel graphviz-devel openldap-dvel python-devel \
	     libxml2-devel krb5-devel gsl-devel qt-devel motif-devel motif \
	     blas-devel lapack-devel xfsprogs cabextract xorg-x11-font-utils \
	     fontconfig xorg-x11-server-Xvfb xorg-x11-fonts-Type1 \
	     xorg-x11-fonts-75dpi xorg-x11-fonts-100dpi dejavu-sans-fonts urw-fonts \
	     giflib-devel libtiff-devel libjpeg-turbo-devel lz4-devel xz-devel \
	     gl2ps-devel postgresql-devel libsqlite3x-devel pythia8-devel \
	     davix-devel srm-ifce-devel tbb-devel python2-numpy
	
	wget https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
	sudo yum install msttcore-fonts-installer-2.6-1.noarch.rpm
	rm -f msttcore-fonts-installer-2.6-1.noarch.rpm
    fi
    mkdir -p $ROOTSYS/{sources,6-14-02,6-14-02-build}
    cd $ROOTSYS
    git clone http://github.com/root-project/root.git sources
    cd sources
    git checkout -b v6-14-02 v6-14-02
    cd ../6-14-02-build
    cmake -Dbuiltin_xrootd=ON -DCMAKE_INSTALL_PREFIX=$ROOTSYS/6-14-02 ../sources
    cmake --build . --target install -- -j8
    cd
    source $ROOTSYS/6-14-02/bin/thisroot.sh
fi

#install dim if necessary

if [ "${DIMREP}" == "y" ];
then
    echo ""
    echo "-------------------"
    echo "DIM INSTALLATION"
    echo "-------------------"
    cd
    curl -o compileDIM.csh https://gist.githubusercontent.com/MBoretto/d8156bb86c726bcf5014/raw/2940a4480ec79b7ceebdfda912b0bba27e66395e/compileDIM.csh
    sed -i 's/dim_v20r15/dim_v20r23/g' compileDIM.csh
    chmod +x compileDIM.csh
    sudo tcsh -c "./compileDIM.csh"
    cd
fi

#install levbdim if necessary
if [ "${LEVBDIMREP}" == "y" ];
then
    echo ""
    echo "-------------------"
    echo "LEVBDIM INSTALLATION"
    echo "-------------------"
    cd
    git clone http://github.com/mirabitl/levbdim.git levbdim
    cd /tmp
    tar zxf ${HOME}/levbdim/web/mongoose.tgz
    cd mongoose-cpp/
    mkdir -p build/
    cd build/
    rm -rf *
    cp ${HOME}/levbdim/web/CMakeLists.txt ../
    cmake -DEXAMPLES=ON -DWEBSOCKET=OFF -DHAS_JSONCPP=ON ..
    make -j4
    sudo make install
    cd ${HOME}/levbdim
    export DIMDIR="/usr/local/lib/dim"
    sudo ln -s /usr/local/include/dim $DIMDIR/dim
    sudo ln -s $DIMDIR $DIMDIR/linux
    scons
    sudo cp lib/* $DIMDIR/
    cd
fi

# install lcio if necessary
# for the time being it is not used by Anpan
if [ "${LCIOREP}" == "y" ];
then
    echo ""
    echo "-------------------"
    echo "LCIO INSTALLATION"
    echo "-------------------"
    cd
    git clone https://github.com/iLCSoft/LCIO.git lcio
    cd lcio
    git checkout v02-12-01
    mkdir -p build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=/opt/lcio ..
    # to speed up the building process you can do
    # "cmake --build . -- -jN" where N is the number of available cores
    cmake --build .
    sudo make install
    cd ../..
    rm -rf lcio
fi

# ------------------------ PYRAME --------------------------

# More info on the pyrame installation can be found on this webpage:
# http://llr.in2p3.fr/sites/pyrame/documentation/howto_install.html
echo "-------------------"
echo "PYRAME INSTALLATION"
echo "-------------------"
echo "More info on the pyrame installation can be found on this webpage:"
echo "http://llr.in2p3.fr/sites/pyrame/documentation/howto_install.html"
echo "This is a modified version of Pyrame tailored to the WAGASCI Experiment"

# Download the sources from GitHub
echo "Insert the directory where you would like to clone the pyrame repository"
echo "Don't insert the trailing slash. The default one is \"${HOME}\"."
echo "Just press OK if you want to clone it in the $HOME folder."
read PYRAME_DIR
if [ -z "$PYRAME_DIR" ]; then
    PYRAME_DIR=${HOME}
fi

# In Debian systems you might need to create links for lua.h and liblua.so
if [ $UBUNTU == "y" ];
then
    sudo ln -sf /usr/lib/x86_64-linux-gnu/liblua5.2.so /usr/lib/liblua.so
    sudo ln -sf /usr/include/lua5.2/lua.h /usr/include/lua.h
    sudo ln -sf /usr/include/lua5.2/luaconf.h /usr/include/luaconf.h
    sudo ln -sf /usr/include/lua5.2/lualib.h /usr/include/lualib.h
    sudo ln -sf /usr/include/lua5.2/lauxlib.h /usr/include/lauxlib.h
fi
# check for previous installs
if [ -d "${PYRAME_DIR}/pyrame" ];
then
    cd "${PYRAME_DIR}/pyrame"
    sudo make uninstall
    cd ..
    sudo rm -rf pyrame
fi

cd "${PYRAME_DIR}"
git clone https://github.com/LastStarDust/pyrame.git pyrame
cd pyrame

# configure and install
chmod +x ./configure
./configure
make
sudo -E make install

# make documentation
cd docs
sudo -E make install
cd ..

# install and enable apache2
if [ $UBUNTU == "y" ];
then
    sudo "${PYRAME_DIR}/pyrame/xhr/install_xhr_debian8_apache2.sh"
    sudo systemctl restart apache2
    sudo systemctl enable apache2
elif  [ $CENTOS == "y" ];
then
    sudo "${PYRAME_DIR}/pyrame/xhr/install_xhr_centos7_apache2.sh"
    sudo systemctl restart httpd
    sudo systemctl enable httpd
fi

# The following command is equivalent to
# echo 1 > sudo tee /proc/sys/net/ipv4/tcp_tw_recycle
# echo 1 > sudo tee /proc/sys/net/ipv4/tcp_fin_timeout
# tcp_tw_recycle is not available in ubuntu since kernel 4.11,
# moreover this is  strictly  a  violation  of the TCP specification.
# In Linux 2.2, the default value for tcp_fin_timeout was 180 seconds.
# I assumed that if the OS is CentOS that machine will only be used
# as a DAQ machine with limited internet capabilities and so I allow
# for a quick recycling of TCP connections. This is at expense of a
# stable internet connection
if [ $CENTOS == "y" ];
then
    echo 1 > sudo tee /proc/sys/net/ipv4/tcp_tw_recycle
    echo 1 > sudo tee /proc/sys/net/ipv4/tcp_fin_timeout
    sudo cp -f "${PYRAME_DIR}/pyrame/launcher/99-pyrame.conf" /etc/sysctl.d/
fi  

# --------------------- ANPAN ---------------------

# More info on the anpan installation can be found on this webpage:
# http://llr.in2p3.fr/sites/pyrame/anpan/documentation/install.html

echo "-------------------"
echo "ANPAN INSTALLATION"
echo "-------------------"
echo "The anpan software based on calicoes 3.0"
echo "More info on the calicoes installation can be found on this webpage:"
echo "http://llr.in2p3.fr/sites/pyrame/calicoes/documentation/install.html"

# Download the sources from GitHub
echo "Insert the directory where you would like to clone the anpan repository"
echo "Don't insert the trailing slash. The default one is \"${HOME}\"."
echo "Just press OK if you want to clone it in the $HOME folder."
read ANPAN_DIR
if [ -z "$ANPAN_DIR" ]; then
    ANPAN_DIR=${HOME}
fi

# check for previous installs
if [ -d "${ANPAN_DIR}/anpan" ];
then
    cd "${ANPAN_DIR}/anpan"
    sudo make uninstall
    cd ..
    sudo rm -rf anpan
fi

cd "$ANPAN_DIR"
git clone https://github.com/LastStarDust/anpan.git anpan
cd anpan

# compile and install

# I noticed that sometimes not all the scripts are copied in the /usr/local/bin
# directory. This may be due to a misconfiguration of the Makefiles
# In case try to manually run the specific Makefile inside each subdirectory. 

sudo ./install.sh
make
sudo make install

# install documentation   
cd docs/documentation
make
sudo mkdir -p /opt/anpan/doc
sudo make install
cd ../..

echo "Post-configuration..."
cd
sudo cp /opt/couchdb/etc/local.ini /opt/couchdb/etc/local.ini.backup
sudo chown couchdb:couchdb /opt/couchdb/etc/local.ini.backup
sudo sed -i '/\[httpd\]/a socket_options = [{nodelay, true}]' /opt/couchdb/etc/local.ini

if [ ! -L "/var/www/html/phygui_rc" ];
then
    sudo ln -s /opt/anpan/phygui_rc /var/www/html/phygui_rc
fi

sudo systemctl enable couchdb
sudo systemctl restart couchdb
sudo systemctl enable pyrame
sudo systemctl restart pyrame

sleep 2s

if [ $UBUNTU == "y" ];
then
    sensible-browser http://localhost/phygui_rc &
elif  [ $CENTOS == "y" ];
then
    firefox http://localhost/phygui_rc &
fi


echo "Installation successfully completed! Thanks for using Anpan"
echo "For any questions about this script please contact:"
echo "Pintaudi Giorgio (PhD Student)"
echo "Yokohama National University"
echo "giorgio-pintaudi-kx@ynu.jp"

exit 0

# AnpanInstaller.sh
#
# Copyright (C) 2018 by Pintaudi Giorgio <giorgio-pintaudi-kx@ynu.jp>
# Released under the GPLv3 license
#
#     Pintaudi Giorgio (PhD Student)
#     Yokohama National University
#     giorgio-pintaudi-kx@ynu.jp