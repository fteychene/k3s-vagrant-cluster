#!/bin/env bash

set -euo pipefail

echo "Stop VMs"
vagrant destroy --force

echo "Clean fetched ressources"
rm -R fetched