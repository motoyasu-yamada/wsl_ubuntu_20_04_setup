sudo apt-get -y update
sudo apt-get install ruby

sudo apt-get install -y apt-utils 
sudo apt-get install -y build-essential
sudo apt-get install -y git-core 
sudo apt-get install -y vim

# bundler
sudo apt-get install -y bundler
sudo gem install bundler:2.1.4

# YARN
sudo apt-get -y remove cmdtest
sudo apt-get -y remove yarn
sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
sudo echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update 
sudo apt-get -y install yarn

# rbenv
export RBENV_ROOT=/usr/local/rbenv
export PATH=$RBENV_ROOT/bin:$PATH
sudo /bin/bash -c "echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile"
sudo apt-get remove rbenv
sudo git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT
sudo /bin/bash -c "echo 'eval "$(/usr/local/rbenv/bin/rbenv init -)"' >> /etc/profile"
sudo -s 'eval "$(/usr/local/rbenv/bin/rbenv init -)"'
sudo mkdir -p $RBENV_ROOT/plugins
sudo git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build

# nodeenv
export NODENV_ROOT=/usr/local/nodenv
export PATH=$NODENV_ROOT/bin:$PATH
sudo /bin/bash -c "echo 'export PATH=/usr/local/nodenv/bin:$PATH' >> /etc/profile"
sudo apt-get remove nodeenv
sudo git clone https://github.com/OiNutter/nodenv /usr/local/nodenv
sudo /bin/bash -c "echo 'eval \"$(/usr/local/nodenv/bin/nodenv init -)\"' >> /etc/profile"
sudo -s 'eval "$(/usr/local/nodenv/bin/nodenv init -)"'
sudo mkdir -p $NODENV_ROOT/plugins
sudo git clone https://github.com/OiNutter/node-build $NODENV_ROOT/plugins/node-build

# Google chrome
sudo /bin/bash -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo curl -sS https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo apt-get -y update
sudo apt-get install -y google-chrome-stable

# etc
sudo git config --global credential.helper store

# mysql
sudo apt-get install libmysqlclient-dev
sudo apt-get install -y mysql-server
sudo apt-get install -y mysql-client
sudo usermod -d /var/lib/mysql mysql
sudo service mysql start
sudo mysql << EOS
USE mysql;
UPDATE user SET plugin='mysql_native_password' WHERE User='root';
FLUSH PRIVILEGES;
EOS

sudo mysql_tzinfo_to_sql /usr/share/zoneinfo/ | sudo mysql -u root mysql

# sqlite3
sudo apt-get install -y sqlite3
sudo apt-get install libsqlite3-dev
