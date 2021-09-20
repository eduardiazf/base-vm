Install vagrant-sshfs

vagrant plugin install vagrant-sshfs


## Creating the VM with custom disk space

run the vagrant up command in the base-vm folder with the VAGRANT_EXPERIMENTAL environment variable, this should be done in a linux-type terminal like git-bash in windows

```bash
    VAGRANT_EXPERIMENTAL="disks" vagrant up
```

creates the virtual machine with the especified size in ./Vagrantfile:14

```bash
cat /vagrant/setup/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
```

sudo fdisk /dev/sda

then delete the /dev/sda5

d  

then delete the /dev/sda2

d

then create a new partition

n

hit enter to created it and in the last sector promp put the desired size +70GB in my case

+70GB

## Get Kubertenes

gcloud components install kubectl