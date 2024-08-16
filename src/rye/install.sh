#!/bin/sh

# Exit immediately on error
set -o errexit

echo "Activating feature 'rye'"

# https://containers.dev/guide/feature-authoring-best-practices#detect-the-non-root-user
echo "Running the rye install script as the non-root user: $_REMOTE_USER"
su - $_REMOTE_USER << 'EOF'

# https://rye.astral.sh/guide/installation/#customized-installation
curl -sSf https://rye.astral.sh/get | RYE_INSTALL_OPTION="--yes" bash

echo "Adding 'rye' to the PATH for the non-root user"
echo 'source "$HOME/.rye/env"' >> ~/.bashrc

EOF

echo "Adding 'rye' to the PATH for the root user"
echo 'source "/home/$_REMOTE_USER/.rye/env"' >> ~/.bashrc

if [ "$BASHCOMPLETION" = "true" ]; then
  echo "Activating bash completion for 'rye'"
  # https://rye.astral.sh/guide/installation/#shell-completion
  /home/$_REMOTE_USER/.rye/shims/rye self completion >/etc/bash_completion.d/rye
else
  echo "Skipping setting up bash completion for 'rye'"
  echo "The value of BASHCOMPLETION is: $BASHCOMPLETION"
fi
