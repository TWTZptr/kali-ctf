#!/bin/sh

# Start sshd service
service ssh start >/dev/null 2>&1

# Start user command
/bin/sh -c "$@"
