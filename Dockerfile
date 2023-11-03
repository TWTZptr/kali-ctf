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

# Install ZSH and openssh-server
RUN apt update && apt install -y zsh openssh-server

# Set ZSH as default shell
RUN chsh -s /bin/zsh

# Configure sshd
RUN mkdir /run/sshd \
  && sed -i 's/#Port 22/Port 10122/' /etc/ssh/sshd_config \
  && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
  && sed -i 's/UsePAM yes/#UsePAM yes/' /etc/ssh/sshd_config

# Open $SSHD_PORT port for connection
EXPOSE $SSHD_PORT

# Copy *.sh and requirements.txt to /bin directory
COPY entrypoint.sh /bin/entrypoint.sh
COPY *requirements* /tmp

# Install requirements
RUN sed -e 's/sudo //g' /tmp/install_requirements.sh > /tmp/install_requirements_no_sudo.sh \
  && chmod +x /tmp/install_requirements_no_sudo.sh \
  && /tmp/install_requirements_no_sudo.sh \
  && rm -rf /tmp/*

# Install libssl1.1
RUN curl http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb -o /tmp/temp.deb \
  && dpkg --install /tmp/temp.deb \
  && rm -rf /tmp/temp.deb

# Install ZeroTier
RUN curl https://install.zerotier.com/ | bash || true

# Add ZeroTier volume with identity and nodes configurations
RUN mkdir -p /var/lib/zerotier/networks.d \
  && chown zerotier-one: /var/lib/zerotier/networks.d \
  && ln -dsf /var/lib/zerotier/networks.d /var/lib/zerotier-one/networks.d \
  && ln -sf /var/lib/zerotier/identity.public /var/lib/zerotier-one/identity.public \
  && ln -sf /var/lib/zerotier/identity.secret /var/lib/zerotier-one/identity.secret

# Install and setup samba
RUN apt install -y samba
RUN rm /etc/samba/smb.conf \ 
  && echo '[workspace]\n \
    path = /workspace\n \
    browseable = yes\n \
    read only = no\n' > /etc/samba/smb.conf \
  && echo "${USER_PASSWORD}\n${USER_PASSWORD}" | smbpasswd -a root

# Run container
RUN chmod ug+x /bin/entrypoint.sh
ENTRYPOINT [ "/bin/entrypoint.sh" ]
