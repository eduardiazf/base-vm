# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

#setup some needed parameters
settings = YAML.load_file 'settings.yaml'
user = settings['user']
username = "vagrant"

Vagrant.configure("2") do |config|
  config.vm.box = "eduardiazf/base-vbox"

  config.vm.disk :disk, size: "40GB", primary: true
  config.vm.provision "file", source: "./setup", destination: "/home/vagrant/setup"

  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  config.vm.provider :virtualbox do |v, override|
    v.customize ["modifyvm", :id, "--cpus", settings["vm"]["cpus"]]
  end

  config.vm.provider :virtualbox do |v, override|
    v.customize ["modifyvm", :id, "--memory", settings["vm"]["memory"]]
  end

  config.vm.provision "shell" do |s|
    s.name = "Setup Script"
    s.inline = "/bin/bash /home/vagrant/setup/do_setup.sh"
    s.env = {
      "USERNAME": user["name"],
      "EMAIL": user["email"]
    }
  end

  if settings["syncfolders"]
    settings["syncfolders"].each do |sf|
      config.vm.synced_folder sf["host"], sf["guest"], type: sf["type"],
        ssh_opts_append: "-o Compression=yes -o CompressionLevel=5",
        sshfs_opts_append: "-o auto_cache -o cache_timeout=115200",
        disabled: false
    end
  end

  if settings["forwardedports"]
    settings["forwardedports"].each do |fp|
      config.vm.network "forwarded_port", guest: fp["guest"], host: fp["host"], auto_correct: true, protocol: "tcp"
    end
  end
end
