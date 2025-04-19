#!/usr/bin/env bash
# Helper Script for automatic nixos updates
set -exu

# Change to nixos config directory
cd /home/ryan/nixos-config-files/

# Update the flake, and commit the lock file
/run/wrappers/bin/sudo -u ryan nix flake update --commit-lock-file
