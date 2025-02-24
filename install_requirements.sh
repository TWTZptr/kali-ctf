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
    rlwrap \
    net-tools

# Install programming packages from repos
sudo apt install -y \
    python3 \
    python3-pip

# Install reverse packages from repos
sudo apt install -y \
    gdb-multiarch \
    gdbserver \
    edb-debugger \
    strace \
    ltrace \
    checksec

# Install pwn packages from repos
sudo apt install -y \
    ropper

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
    binwalk \
    wordlists

# Install crypto packages from repos
sudo apt install -y \
    hashcat \
    fcrackzip

# Install stego packages from repos
sudo apt install -y \
    stegseek

# Install python packages
pip --no-cache-dir install --root-user-action=ignore --ignore-requires-python -r /tmp/requirements.txt

# Clean cache
sudo rm -rf /var/cache/apt/archives /var/lib/apt/lists
