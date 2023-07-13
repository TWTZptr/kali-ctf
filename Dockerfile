# Pull last Kali version
FROM kalilinux/kali-rolling

# Set user password by default
ARG USER_PASSWORD="root"

# Set sshd port by default
ARG SSHD_PORT=10122

# Configure WSL2 for X11 Forwarding
ENV DISPLAY=:0
ENV WAYLAND_DISPLAY=wayland-0
ENV PULSE_SERVER=unix:/tmp/PulseServer
ENV XDG_RUNTIME_DIR=/tmp/runtime-dir

# Create workspace directory
WORKDIR /workspace

# Change user password to $USER_PASSWORD
RUN echo "root:$USER_PASSWORD" | chpasswd

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
  gdb \
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
  openssh-server \
  python3 \
  python3-pip \
  rlwrap \
  sqlmap \
  ssh \
  vim \
  wget

# Symlink python3 to python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install [Cheat](https://github.com/cheat/cheat/blob/master/INSTALLING.md)
RUN cd /tmp \
  && wget https://github.com/cheat/cheat/releases/download/4.4.0/cheat-linux-amd64.gz \
  && gunzip cheat-linux-amd64.gz \
  && chmod +x cheat-linux-amd64 \
  && mv cheat-linux-amd64 /usr/local/bin/cheat

# Configure sshd
RUN mkdir /run/sshd \
  && sed -i 's/#Port 22/Port 10122/' /etc/ssh/sshd_config \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
  && sed -i 's/UsePAM yes/#UsePAM yes/' /etc/ssh/sshd_config

# Open $SSHD_PORT port for connection
EXPOSE $SSHD_PORT

# Copy entrypoint.sh to /bin/entrypoint.sh
COPY entrypoint.sh /bin/entrypoint.sh

# Run container
ENTRYPOINT [ "/bin/entrypoint.sh" ]
