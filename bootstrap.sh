#!/bin/bash
function install {
  echo installing $1
  shift
  sudo apt-get -y install "$@" >/dev/null 2>&1
}

cd ~

echo updating package information
sudo apt-add-repository -y ppa:nginx/stable >/dev/null 2>&1
sudo apt-get -y update >/dev/null 2>&1

install 'build-essential' build-essential
install 'software-properties-common' software-properties-common
install 'python-software-properties' python-software-properties

# Packages required for compilation of some stdlib modules
install Requirements tklib zlib1g-dev libssl-dev libreadline-dev libxml2 libxml2-dev libxslt1-dev libmysqlclient-dev
install SQLite sqlite3 libsqlite3-dev
install Git git
install Nodejs nodejs npm
install Nginx nginx

echo setup rbenv
touch ~/.bash_profile
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv >/dev/null 2>&1
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build >/dev/null 2>&1
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
eval "$(rbenv init -)"

echo installing ruby
rbenv install 2.3.0
rbenv global 2.3.0
rbenv rehash
ruby -v

echo installing rails
gem install bundler
gem install rails -v 4.2.5
rbenv rehash

echo 'installing global bower & gulp'
sudo npm install -g bower >/dev/null 2>&1
sudo npm install -g gulp >/dev/null 2>&1

# Add symbolic
sudo ln -s /usr/bin/nodejs /usr/bin/node >/dev/null 2>&1

# Needed for docs generation.
sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set.'
