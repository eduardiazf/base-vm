apt-get update -y
apt-get install build-essential procps curl file git -y

git config --global user.name $USERNAME
git config --global user.email $EMAIL

if [ ! -f /vagrant/setup/id_rsa ]; then
    ssh-keygen -b 2048 -t rsa -C $EMAIL -f /vagrant/setup/id_rsa -q -N ""
    cat /vagrant/setup/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
fi

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

echo -e "Installing brew"
if [ ! -f /home/vagrant/.linuxbrew/Homebrew/bin/brew ]; then
  git clone https://github.com/Homebrew/brew /home/vagrant/.linuxbrew/Homebrew
  mkdir /home/vagrant/.linuxbrew/bin
  chown -R vagrant:vagrant /home/vagrant/.linuxbrew
  ln -Fs /home/vagrant/.linuxbrew/Homebrew/bin/brew /home/vagrant/.linuxbrew/bin
fi
