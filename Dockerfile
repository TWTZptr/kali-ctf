# Pull last Kali version
FROM kalilinux/kali-rolling

# Configure WSL2 for X11 Forwarding
ENV DISPLAY=:0
ENV WAYLAND_DISPLAY=wayland-0
ENV PULSE_SERVER=unix:/tmp/PulseServer
ENV XDG_RUNTIME_DIR=/tmp/runtime-dir

# Create workspace directory
WORKDIR /workspace

# Install ZSH
RUN apt update && apt install -y zsh

# Set ZSH as default shell
RUN chsh -s /bin/zsh

# Install required packages
RUN apt install -y \
  binwalk \
  curl \
  dirsearch \
  fcrackzip \
  gdbserver \
  git \
  hashcat \
  inetutils-ping \
  less \
  man \
  nano \
  netcat-traditional \
  nikto \
  nmap \
  python3 \
  python3-pip \
  rlwrap \
  sqlmap \
  ssh \
  vim \
  wget

# Symlink python3 to python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install [volatility3](https://github.com/volatilityfoundation/volatility3)
RUN cd /tmp \
  && git clone https://github.com/volatilityfoundation/volatility3 \
  && chmod +x volatility3/vol.py \
  && mv volatility3 /opt \
  && ln -s /opt/volatility3/vol.py /usr/bin/vol.py \
  && ln -s /opt/volatility3/vol.py /usr/bin/volatility \
  && apt install -y python3 python3-dev libpython3-dev python3-pip python3-setuptools python3-wheel \
  && pip install -r /opt/volatility3/requirements.txt

# Install [Cheat](https://github.com/cheat/cheat/blob/master/INSTALLING.md)
RUN cd /tmp \
  && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && mv cheat-linux-amd64 /usr/local/bin/cheat

# Run container
ENTRYPOINT [ "/bin/sh", "-c" ]
