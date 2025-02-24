# Pull last Kali version
FROM kalilinux/kali-rolling

# Set user password by default
ARG USER_PASSWORD="root"

# Set sshd port by default
ARG SSHD_PORT=10122

# Create workspace directory
WORKDIR /workspace

# Change user password to $USER_PASSWORD
RUN echo "root:$USER_PASSWORD" | chpasswd

# Install ZSH, openssh-server, samba and cifs-utils
RUN apt update && apt install -y zsh cifs-utils

# Set ZSH as default shell
RUN chsh -s /bin/zsh

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

RUN chmod ug+x /bin/entrypoint.sh
ENTRYPOINT [ "/bin/entrypoint.sh" ]
