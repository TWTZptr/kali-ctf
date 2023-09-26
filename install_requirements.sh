#!/bin/sh
set -e

# Update system
sudo apt update
sudo apt -y upgrade

# Install сommon packages from repos
sudo apt install -y \
    git \
    vim \
    ssh \
    nano \
    man \
    less \
    rlwrap

# Install programming packages from repos
sudo apt install -y \
    python3 \
    python3-pip

# Install reverse packages from repos
sudo apt install -y \
    gdb \
    gdbserver \
    strace \
    ltrace \
    checksec

# Install web packages from repos
sudo apt install -y \
    wget \
    curl \
    dirsearch \
    inetutils-ping \
    netcat-traditional \
    sqlmap \
    nikto \
    nmap

# Install forensic packages from repos
sudo apt install -y \
    binwalk

# Install crypto packages from repos
sudo apt install -y \
    hashcat \
    fcrackzip

# Install [Cheat](https://github.com/cheat/cheat/blob/master/INSTALLING.md)
cd /tmp \
    && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
    && gunzip cheat-linux-amd64.gz \
    && sudo chmod +x cheat-linux-amd64 \
    && sudo mv cheat-linux-amd64 /usr/local/bin/cheat

# Install [GDB dashboard](https://github.com/cyrus-and/gdb-dashboard)
wget -P ~ https://git.io/.gdbinit

# Install python packages
pip --no-cache-dir install --root-user-action=ignore --ignore-requires-python -r /tmp/requirements.txt

# Clean cache
sudo rm -rf /var/cache/apt/archives /var/lib/apt/lists
