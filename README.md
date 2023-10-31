# Description
This repository contains the [Kali Linux](https://en.wikipedia.org/wiki/Kali_Linux) build for [Capture the Flag](https://en.wikipedia.org/wiki/Capture_the_flag_(cybersecurity))


# TL;DR
```bash
docker volume create kali-ctf >nul 2>&1 & docker exec -ti ctf "/bin/zsh" 2>nul || docker start ctf >nul 2>&1 && docker attach ctf 2>nul || docker run --privileged -ti --name ctf -v kali-ctf:/var/lib/zerotier/ -p 10122:10122 ghcr.io/niapollab/kali-ctf:master "/bin/zsh"
```


# Build Image
```bash
docker build --pull --tag kali-ctf .
```


# Build Volume
```bash
docker volume create kali-ctf
```


# Build container
## Before starting
If you want to use GUI application inside docker container install Alpine before:
1. Install **Alpine** from [Microsoft Store](https://apps.microsoft.com/store/detail/alpine-wsl/9P804CRF0395?hl=en-gb&gl=gb) or:
```bash
winget install --disable-interactivity alpine
```
2. Run **Alpine.exe**
3. Open **DockerDesktop.exe**. Goto `Settings -> Resources -> WSL Integration`, turn on **Alpine** support and click `Apply & restart`.


## With GUI support
```bash
docker create --privileged -ti --name ctf -v kali-ctf:/var/lib/zerotier/ -p 10122:10122 --mount "type=bind,src=\\wsl.localhost\Alpine\mnt\wslg,dst=/tmp" kali-ctf "/bin/zsh"
```


## Without GUI support
```bash
docker create --privileged -ti --name ctf -v kali-ctf:/var/lib/zerotier/ -p 10122:10122 kali-ctf "/bin/zsh"
```


# Configure container
## Register your own ZeroTier identity
If you want to use your own local network through ZeroTier register identity. It's need for saving identity context through docker containers:
```bash
mkdir -p /var/lib/zerotier && zerotier-one -i generate /var/lib/zerotier/identity.secret /var/lib/zerotier/identity.public && chown zerotier-one:zerotier-one /var/lib/zerotier/*
```


# Run container
Run [ctf.cmd](ctf.cmd) or use command:
```docker start ctf & docker attach ctf```
