#!/bin/bash

## Before executing this script make sure you have installed clang and the
## GNUstep runtime 1.9, f.e. using https://github.com/plaurent/gnustep-build


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

showPrompt

. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh

# Set clang as compiler and set linker flags
export CC=clang
export CXX=clang++
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

# These should be build before the apps
# There are some issues currently
# PDFKit needs to be build using root
# PDFKit depends on freetype-config which has been superseeded by pkgconfig on debian buster (builds nonetheless
# don't know if it works correctly, though.)
echo -e "\n\n"
echo -e "${GREEN}Building gap/libs before GAP...${NC}"
cd ../gap/libs
make clean
make -j8
sudo -E make install

showPrompt

echo -e "\n\n"
echo -e "${GREEN}Building apps from GNUstep Application Project (GAP)...${NC}"
cd ..
make clean
make -j8
sudo -E make install

echo -e "\n\n"
echo -e "${GREEN}Install is done. Open an app using openapp <name>.${NC}"
