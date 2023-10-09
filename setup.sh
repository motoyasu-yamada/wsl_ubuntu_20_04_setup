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
sudo apt-get install -y libyaml-dev
sudo apt-get install -y libmariadb-dev
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

sudo mkdir -p $(anyenv root)/plugins
sudo git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update

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
sudo apt-get install -y tzdata
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

# Docker
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script
curl -fsSL https://get.docker.com -o ~/get-docker.sh
sudo sh ~/get-docker.sh
sudo usermod -aG docker spicysoft

# Docker-Compose
# https://mabdullahabid.medium.com/docker-convenience-script-135146277323
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Elasticsearch
# https://www.elastic.co/guide/en/elasticsearch/reference/current/deb.html
curl -sS https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
sudo apt-get install apt-transport-https
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update
sudo apt-get install -y elasticsearch
## 以下手作業
# sudo vi /etc/elasticsearch/elasticsearch.yml
# xpack.security.enabled: false
# xpack.security.http.ssl.enabled: false
sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

# kuromoji-tokenizer
sudo systemctl stop elasticsearch.service
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
sudo /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-kuromoji
sudo systemctl start elasticsearch.service
curl http://localhost:9200/_nodes/plugins?pretty

# Kibana
sudo apt-get install -y kibana
sudo systemctl enable kibana
sudo systemctl start kibana

# nginxインストール
sudo apt install -y nginx
sudo service nginx start
sudo adduser --system --no-create-home --shell /bin/false --group --disabled-login nginx

# AWSツールのインストール
sudo apt install -y awscli