#!/bin/bash
RED='\033[0;31m' # red color
GREEN='\033[0;32m' # green color
YELLOW='\033[1;33m' # yellow color
NC='\033[0m' # no color

PKGMAN="apt-get"

LOG_INFO="${GREEN}[=]${NC}"
LOG_WARNING=$"${YELLOW}[!]${NC}"

DEPENDENCIES="git make cbindgen gcc pkg-config libtool m4 automake libpcre2-dev libyaml-dev libjansson-dev libpcap-dev libcap-ng-dev libmagic-dev liblz4-dev rustc cargo libunwind-dev zlib1g zlib1g-dev"

printf "${LOG_WARNING} ${YELLOW}administration privilege required to perform this operation by \"sudo\"${NC}\n"
printf "${LOG_INFO} loading dependencies...\n"
for pkg in $DEPENDENCIES; do
	printf "\t${GREEN}${pkg}${NC}\n"
done
printf "${LOG_INFO} installing all dependencies\n"
sudo $PKGMAN install -y $DEPENDENCIES > /dev/null 2>&1
printf "${LOG_INFO} installed all dependencies\n"

printf "${LOG_INFO} cloning \"suricata\" from \"https://github.com/OISF/suricata\"\n"
git clone https://github.com/OISF/suricata > /dev/null 2>&1
printf "${LOG_INFO} cloning \"suricata/libhtp\" from \"https://github.com/OISF/libhtp\"\n"
cd suricata
git clone https://github.com/OISF/libhtp > /dev/null 2>&1
cd libhtp
printf "${LOG_INFO} building and installing target \"suricata/libhtp\"\n"
./autogen.sh > /dev/null 2>&1
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
cd ..
printf "${LOG_INFO} building and installing target \"suricata\"\n"
./autogen.sh > /dev/null 2>&1
./autogen.sh
./configure
make
sudo make install-full
printf "${LOG_INFO} reached target \"suricata\"\n"
