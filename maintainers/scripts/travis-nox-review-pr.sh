#! /usr/bin/env bash
set -e

# Only run for pull requests
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  echo "Not a pull request, checking evaluation"
  nix-env -f. -qaP --drv-path
  exit 0
fi

# Install Nix
bash <(curl https://nixos.org/nix/install)
source $HOME/.nix-profile/etc/profile.d/nix.sh

echo "Installing nox"
git clone https://github.com/madjar/nox
nix-env -if nox

echo "Reviewing PR"
# The current HEAD is the PR merged into origin/master, so we compare
# against origin/master
nox-review wip --against origin/master
