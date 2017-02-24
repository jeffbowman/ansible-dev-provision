# ansible-dev-provision

Ansible roles for provisioning Vagrant Java/Mulesoft development
environment. I frequently move from one client to the next or work for
multiple different clients. I use this approach to allow me to
configure a development environment with the tools specific to a
particular client.

At it's base, only a development environment including AnypointStudio,
Java 8, IntelliJ Community Edition, Emacs, Vim running
on [Arch Linux](https://www.archlinux.org) and
using [XFCE4](https://www.xfce.org) as the window manager.

Additional optional software currently configured to install is:

* Elasticsearch
* Kibana

But these must be mentioned in the Vagrantfile to enable installing
them. They are not provided by default.

## Getting Started

These instructions will get you started. Some caveats:

* This satisfies my needs
* This may work for you
* This is still a work in progress. I have tried to move specifics out
  of the scripts and into the Vagrant file

### Prerequisites

Install required software: 

* [Vagrant](https://vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

[Ansible](https://www.ansible.com) is used from the guest, so it
should not be required to install on the host, but you may choose to
do that at your option.

### Installing

* `vagrant init ogarcia/archlinux-x64`
* Provide a shared mount for the .m2/repository directory, this will
  help cut down on the amount of disk space used by the box, and
  speeds compile times as you probably already have your depenencies
  on the host (N.B. $HOME won't work, you need to replace that with 
  your actual path to your .m2 directory. On Linux machines this is 
  $HOME, on Windows it may be somewhere else).
  - `config.vm.synced_folder "/$HOME/.m2/repository", "/home/vagrant/.m2/repository", owner: "vagrant", group: "users"`
* Optionally, mount the "/vagrant" directory as "/home/vagrant/git" in the vm.
  - `config.vm.synced_folder "/path/to/Vagrantfile" "/home/vagrant/git"`
* Use the following configuration in the Vagrantfile:
  - `vb.gui = true`
  - `vb.memory = "8192"` (if possible, adjust as necessary)
  - `vb.cpus = "4"`      (if possible, adjust as necessary)
  - `vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]`
  - `vb.customize ["modifyvm", :id, "--vram", "128"]`
  - `vb.customize ["modifyvm", :id, "--accerate3d", "on"]`
* Setup the provisioning scripts, vagrant allows multiple of them,
  they run in order. The first one installs prerequisites
  including [pacaur](https://aur.archlinux.org/packages/pacaur) and an
  ansible plugin for `pacaur` 
  [ansible-pacaur](https://git.project-insanity.org/onny/ansible-pacaur.git)
  - `config.vm.provision "shell", path: "provision-files/provision.sh"`
  - `config.vm.provision "shell", inline: "ansible-playbook /vagrant/provision-files/provision.yml --extra-vars 'installElasticsearch=yes installKibana=yes'"`
  - `--extra-vars` is used to pass in values for optional
    packages/services, this is an example. If it is not provided, then
    the `installElasticsearch` and `installKibana` default to `no` and
    are not installed. Future optional packages will be handled this
    way as well.
* Cleanup pacman package cache and optimize pacman
  - `config.vm.provision "shell", inline: "/usr/bin/pacman -Scc --noconfirm"`
  - `config.vm.provision "shell", inline: "/usr/bin/pacman-optimize"`
* `git clone git@github.com/jeffbowman/ansible-dev-provision.git provision-files`
* Additional software installed and must be provided by copying the
  respective files into this directory:
  - AnypointStudio.tar.gz [see Mulesoft's website](https://developer.mulesoft.com/dev/anypoint-studio)
  - AnypointStudio.desktop
  - KeePassHttp.plgx [see KeePass pluins](http://keepass.info/plugins.html#keepasshttp), this can bee used with the `PasslFox` Firefox plugin.
  - settings.xml - provide your own
  - SwapCaps.desktop - swap the Caps Lock and left Control keys, I use
    Emacs key bindings, so having the Caps Lock key conveniently
    reachable is important.
  - wallpapers.zip - my own set of wallpapers, I setup XFCE4 to change
    to a different wallpaper every 10 minutes
* if these files aren't available, update the roles to not use them (see the user-config role)
* `vagrant up --provision`

### Final Steps

Assuming everything goes well and there are no errors, you will need
to restart vagrant. Once restared, you will need to login once with a
password which will allow setting up XFCE4 the first time. On the next
restart of the vagrant machine, you should automatically login.

## License

This project is provided as-is with no licensing. Please fork and
customize as you see fit. If you would like to end pull-requests, I'm
happy to mindfully accept them.

## Acknowledgements

* The folks who write and maintain Vagrant, a fantastic idea well
  implemented. I use this all the time.
* The folks who write and maintain VirtualBox, another fantastic tool,
  available at no cost and something else I use all the time.
* [PurpleBooth](https://gist.github.com/PurpleBooth) whose README.md
  template I followed to create this README.md
  
And as a good friend of mine said, "God bless people who put out great
open source "stuff"" (I did paraphrase it, [here is the original tweet](https://twitter.com/cgorshing/status/834544794361802756))
