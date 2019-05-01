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

# Set clang as compiler
export CC=clang-6.0
export CXX=clang++-6.0

# Checkout sources
echo -e "\n\n${GREEN}Checking out sources...${NC}"
git clone https://github.com/gnustep/libs-performance.git
git clone https://github.com/gnustep/libs-webservices.git
git clone https://github.com/gnustep/libs-simplewebkit
git clone https://github.com/gnustep/gap.git

showPrompt

. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh
export CC=clang-6.0
export CXX=clang++-6.0
export OBJCFLAGS="-fblocks -fobjc-runtime=gnustep-1.9"
export LDFLAGS=-ldispatch
export LD_LIBRARY_PATH="/usr/GNUstep/Local/Library/Libraries"

echo -e "\n\n"
echo -e "${GREEN}Building libsperformance...${NC}"
cd libs-performance
make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building libs-webservices...${NC}"
cd ../libs-webservices
make clean
./configure --prefix=/usr
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building libs-simplewebkit...${NC}"
cd ../libs-simplewebkit
make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building gap/libs/netclasses before GAP...${NC}"
cd ../gap/libs/netclasses
make clean
./configure
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building apps from GNUstep Application Project (GAP)...${NC}"
cd ../../
make clean
make -j8
sudo -E make install

echo -e "\n\n"
echo -e "${GREEN}Install is done. Open an app using openapp <name>.${NC}"
