#!/bin/bash

# Server automation script
# Usage: server.sh [update|up|down]

PROJECT_DIR="/mnt/storage/PROJECTS/selfhosted-services"
SERVER_HOST="serverpi_local"
SSH_COMMAND="ssh"

if command -v kitty &> /dev/null; then
  SSH_COMMAND="kitty +kitten ssh"
fi

if [ $# -eq 0 ]; then
  echo "Usage: server.sh [update|up|down]"
  exit 1
fi

COMMAND="$1"
case "$COMMAND" in
  update)
    # shellcheck disable=SC2029
    $SSH_COMMAND "$SERVER_HOST" "cd $PROJECT_DIR && bash update-all.sh"
    ;;
  up)
    # shellcheck disable=SC2029
    $SSH_COMMAND "$SERVER_HOST" "cd $PROJECT_DIR && bash up-all.sh"
    ;;
  down)
    # shellcheck disable=SC2029
    $SSH_COMMAND "$SERVER_HOST" "cd $PROJECT_DIR && bash down-all.sh"
    ;;
  *)
    echo "Invalid command. Use: update, up, or down"
    exit 1
    ;;
esac
