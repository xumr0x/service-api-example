#!/bin/bash

echo "Making sure packages are up to date..."
sudo apt update -y

echo "Installing dependencies for Ruby..."
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev -y

echo "Installing Ruby 2.6.5..."
git clone git://github.com/rbenv/ruby-build.git /usr/local/plugins/ruby-build \
&& /usr/local/plugins/ruby-build/install.sh
ruby-build 2.6.5 /usr/local/

echo "Ruby version: $(ruby -v) is installed."

