#!/bin/bash

## Before executing this script make sure you have installed clang-6.0 and a
## current GNUstep runtime, f.e. using https://github.com/Letterus/gnustep-build-ubuntu/tree/debian-9

# Show prompt function
function showPrompt()
{
  if [ "$PROMPT" = true ] ; then
    echo -e "\n\n"
    read -p "${GREEN}Press enter to continue...${NC}"
  fi
}

# Set colors
GREEN=`tput setaf 2`
NC=`tput sgr0` # No Color

# Set to true to pause after each build to verify successful build and installation
PROMPT=true

# Create build directory
mkdir GNUstep-build-gap
cd GNUstep-build-gap

# Checkout sources
echo -e "\n\n${GREEN}Checking out sources...${NC}"
git clone https://github.com/gnustep/libs-performance.git
git clone https://github.com/gnustep/libs-webservices.git
git clone https://github.com/gnustep/libs-simplewebkit
git clone https://github.com/gnustep/gap.git
svn checkout https://svn.code.sf.net/p/price/code-svn/trunk price-code-svn
git clone https://github.com/ericwa/TextEdit.git
svn checkout http://svn.savannah.nongnu.org/svn/gnustep-nonfsf/frameworks/highlighterkit/ highlighterkit
svn checkout http://svn.savannah.nongnu.org/svn/gnustep-nonfsf/apps/gemas/ gemas
svn checkout http://svn.savannah.nongnu.org/svn/gnustep-nonfsf/frameworks/pantomime/ pantomime
svn checkout http://svn.savannah.nongnu.org/svn/gnustep-nonfsf/apps/gnumail gnumail
wget http://twilightedge.com/downloads/PikoPixel.Sources.1.0-b9e.tar.gz
git clone https://github.com/libical/libical
git clone https://github.com/poroussel/simpleagenda.git
showPrompt

# Set clang as compiler and set linker flags
export CC=clang-8
export CXX=clang++-8
export RUNTIME_VERSION=gnustep-1.9
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export LD=/usr/bin/ld.gold
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/GNUstep/Local/Library/Libraries/
export LDFLAGS="-fuse-ld=/usr/bin/ld.gold -L/usr/local/lib -L/usr/GNUstep/Local/Library/Libraries/ -I/usr/local/include"
export OBJCFLAGS="-fblocks"
export PATH="/usr/GNUstep/System/Tools:/usr/GNUstep/Local/Tools:${PATH}"

. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

echo -e "\n\n"
echo -e "${GREEN}Building libsperformance...${NC}"
cd libs-performance
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building libs-webservices...${NC}"
cd ../libs-webservices
#make clean
./configure --prefix=/usr
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building libs-simplewebkit...${NC}"
cd ../libs-simplewebkit
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building gap/libs before GAP...${NC}"
cd ../gap/libs

#cd Berkelium
#sudo -E make install

cd DataBasinKit
#make clean
make -j8
sudo -E make install

cd ../netclasses
#make clean
./configure
make -j8
sudo -E make install

cd ../Oresme/OresmeKit
#make clean
make -j8
sudo -E make install
cd ..

#cd ../PDFKit
#./configure
#make -j8
#sudo -E make install

cd ../RSSKit
#make clean
make -j8
sudo -E make install

cd ../timeui
#make clean
make -j8
sudo -E make install

showPrompt

# FIXME: You have to remove libs dir from the makefile to make this work (apply patch)
echo -e "\n\n"
echo -e "${GREEN}Building apps from GNUstep Application Project (GAP)...${NC}"
cd ../../
#make clean
make -j8
sudo -E make install PATH=$PATH:/usr/GNUstep/Local/Tools/

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building app PRICE from Sourceforge SVN...${NC}"
cd ../price-code-svn
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building app TextEdit from GitHub...${NC}"
cd ../TextEdit
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building Gemas von GNU Savannah SVN...${NC}"
cd ../highlighterkit
#make clean
make -j8
sudo -E make install

cd ../gemas
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building GNUMail von GNU Savannah SVN...${NC}"
cd ../pantomime
#make clean
make -j8
sudo -E make install

cd ../gnumail
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building PikoPixel from source tarball...${NC}"
cd ..
tar xzf PikoPixel.Sources.1.0-b9e.tar.gz
cd PikoPixel.Sources.1.0-b9e/PikoPixel
#make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building libical and SimpleAgenda from GitHub...${NC}"
cd ../../libical
git checkout v0.48
./configure --prefix=/usr/local
make -j8
sudo -E make install
sudo ldconfig

cd ../simpleagenda
#make clean
make -j8
sudo -E make install

echo -e "\n\n"
echo -e "${GREEN}Install is done. Open an app using openapp <name>.${NC}"
