apt-get update -y
apt-get install build-essential procps curl file git -y

git config --global user.name $USERNAME
git config --global user.email $EMAIL


if [ ! -f /vagrant/setup/id_rsa ]; then
    ssh-keygen -b 2048 -t rsa -C $EMAIL -f /vagrant/setup/id_rsa -q -N ""
    cat /vagrant/setup/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
fi

echo -e "Moving to home directory"
cd /home/vagrant

echo -e "Move zsh configure"
cp -f /vagrant/setup/.zshrc /home/vagrant

echo -e "Coping ssh keys"
cp /vagrant/setup/id_rsa /home/vagrant/.ssh/id_rsa
cp /vagrant/setup/id_rsa.pub /home/vagrant/.ssh/id_rsa.pub

echo -e "Change owner to ssh keys"
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa*

echo -e "Change permission to ssh keys"
chmod 600 /home/vagrant/.ssh/id_rsa
chmod 644 /home/vagrant/.ssh/id_rsa.pub

echo -e "Coping npmrc to home"
cp -r /vagrant/setup/.npmrc /home/vagrant/
chown -R vagrant:vagrant /home/vagrant/.npm*

echo -e "Installing brew"
if [ ! -f /home/vagrant/.linuxbrew/Homebrew/bin/brew ]; then
  git clone https://github.com/Homebrew/brew /home/vagrant/.linuxbrew/Homebrew
  mkdir /home/vagrant/.linuxbrew/bin
  chown -R vagrant:vagrant /home/vagrant/.linuxbrew
  ln -Fs /home/vagrant/.linuxbrew/Homebrew/bin/brew /home/vagrant/.linuxbrew/bin
fi

echo -e "Install Google Cloud SDK"
curl -sSLO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-345.0.0-linux-x86_64.tar.gz
tar xvzf /home/vagrant/google-cloud-sdk-345.0.0-linux-x86_64.tar.gz && rm -f google-cloud-sdk-345.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
chown -R vagrant:vagrant google-cloud-sdk

echo -e "Install mongodb"
#curl https://www.mongodb.org/static/pgp/server-4.0.asc | sudo apt-key add -
#echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" > /etc/apt/sources.list.d/mongodb-org-4.0.list
#apt-get update -y
#apt-get install -y mongodb-org
#systemctl enable mongod

echo -e "Install Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo -e "Install Mysql Client"
sudo apt install mysql-client -y
