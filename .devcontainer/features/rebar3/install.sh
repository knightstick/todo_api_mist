#!/usr/bin/env bash

set -e

echo "Installing Rebar3..."

# Download Rebar3
wget -q -O rebar3 https://s3.amazonaws.com/rebar3/rebar3

# Make it executable
chmod +x rebar3

# Move it to a home-based directory
mkdir -p ~/.local/bin
mv rebar3 ~/.local/bin/rebar3
chmod +x ~/.local/bin/rebar3

cd ~/.local/bin
./rebar3 local install

echo "Rebar3 installed"
