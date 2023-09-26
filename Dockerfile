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

# Copy *.sh to /bin directory
COPY *.sh /bin

# Install requirements
RUN sed -e 's/sudo //g' /bin/install_requirements.sh > /bin/install_requirements_no_sudo.sh \
  && cat /bin/install_requirements_no_sudo.sh \
  && chmod +x /bin/install_requirements_no_sudo.sh \
  && /bin/install_requirements_no_sudo.sh \
  && rm -rf /bin/install_requirements*.sh

# Run container
ENTRYPOINT [ "/bin/entrypoint.sh" ]
