#!/bin/bash

echo -e "\e[34mMaking sure packages are up to date...\e[0m"
sudo apt update -y -q

echo -e "\e[34mInstalling dependencies for Ruby...\e[0m"
sudo apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev -y -q

echo -e "\e[34mInstalling Ruby 2.6.5...\e[0m"
git clone git://github.com/rbenv/ruby-build.git /usr/local/plugins/ruby-build \
&& /usr/local/plugins/ruby-build/install.sh
ruby-build 2.6.5 /usr/local/

echo -e "\e[35mRuby version: $(ruby -v) is installed.\e[0m"

# setup ufw
echo -e "\e[34mSetting up firewall...\e[0m"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

echo -e "\e[35mDone.\e[0m"