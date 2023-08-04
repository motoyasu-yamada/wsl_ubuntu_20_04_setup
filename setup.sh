set -xe
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y apt-utils 
sudo apt-get install -y build-essential
sudo apt-get install -y git-core 
sudo apt-get install -y vim
sudo apt-get install -y wget ca-certificates

# bundler
sudo apt-get install -y ruby
sudo apt-get install -y bundler
sudo gem install bundler:2.2.4 # https://bundler.io/

# YARN
sudo apt-get -y remove cmdtest
sudo apt-get -y remove yarn
sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update 
sudo apt-get -y install yarn

# anyenv /rbenv nodenv
sudo rm -rf ~/.anyenv
sudo rm -rf ~/.config/anyenv/
sudo rm -rf /usr/local/anyenv
sudo git clone https://github.com/riywo/anyenv ~/.anyenv
sudo mv ~/.anyenv /usr/local/anyenv
cat <<'EOS' > /tmp/.add_etc_profile
if [[ ":$PATH:" != *":/usr/local/anyenv/bin:"* ]]; then
  export PATH="/usr/local/anyenv/bin:$PATH"
fi
eval "$(anyenv init -)"
EOS
/bin/bash -c "cat /tmp/.add_etc_profile >> ~/.bash_profile"
/bin/bash /tmp/.add_etc_profile
if [[ ":$PATH:" != *":/usr/local/anyenv/bin:"* ]]; then
  export PATH="/usr/local/anyenv/bin:$PATH"
fi
anyenv install --init
anyenv install nodenv
anyenv install rbenv

# Google chrome
sudo /bin/bash -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get -y update
sudo apt-get install -y google-chrome-stable

# etc
sudo /bin/bash -c "echo 'git config --global credential.helper store' >> /etc/profile"

# mysql
if systemctl is-active --quiet mysql; then
  sudo service mysql stop
fi
sudo apt-get install -y libmysqlclient-dev
sudo apt-get install -y mysql-server
sudo apt-get install -y mysql-client
sudo usermod -d /var/lib/mysql mysql
sudo service mysql start
sudo mysql << EOS
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
FLUSH PRIVILEGES;
EOS

sudo mysql_tzinfo_to_sql /usr/share/zoneinfo/ | sudo mysql -u root mysql

# sqlite3
sudo apt-get install -y sqlite3
sudo apt-get install -y libsqlite3-dev
