#!/bin/sh

# Start sshd service
service ssh start >/dev/null 2>&1

# Start zerotier service
service zerotier-one start >/dev/null 2>&1

# Start samba services
service smbd start >/dev/null 2>&1
service nmbd start >/dev/null 2>&1

# Start user command
/bin/sh -c "$@"
