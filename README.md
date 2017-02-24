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

## Getting Started

These instructions will get you started. Some caveats:

* This satisfies my needs
* This may work for you
* This is still a work in progress. I have tried to move specifics out
  of the scripts and into the Vagrant file

My recommendation is to checkout your project source code into a
project directory, then begin with the instructions below from that
point. The reason for this is to keep your source code outside the box
and on the host in case something goes wrong with the virtual machine
or you delete it you don't also lose your project code.

So, imagine you checkout your code in the following directory:

`/home/me/Projects/my-cool-project/project-source`

I start the install steps below in:

`/home/me/Projects/my-cool-project`

Then mount `/home/me/Projects/my-cool-project` as `/home/vagrant/git`
in my Vagrantfile so that I have access to the project source code in
my `$HOME` directory. Normally, on Linux this is where you should be
working as you have complete permission (by file ownership as well as
by mode) rather than in other directories outside of this where you
(by default) might only have read permission. This is an optional
step, the `/home/me/Projects/my-cool-project` (in this case) is
automatically mounted as `/vagrant` within the box.


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
  - `config.vm.synced_folder "$HOME/.m2/repository", "/home/vagrant/.m2/repository", owner: "vagrant", group: "users"`
* Optionally, mount the "/vagrant" directory as "/home/vagrant/git" in
  the vm. This is just a convenience tip, since you normally login to
  `/home/vagrant`, doing this means your codebase would be contained
  within your `$HOME` directory. It is intended that your source code
  for your project lives outside the box and is mounted within. This
  is to provide the security that if you corrupt your box or run
  `vagrant destroy` you still have your source on the host hard
  drive. (N.B. /path/to/Vagrantfile is simply the full path to where
  you ran the `vagrant init` command from the first step above. It
  should be a directory *not* a full path to the Vagrantfile
  itself. This is just to help you understand which path to use... it
  is the one where the Vagrantfile lives. Hopefully that is clear.)
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
  - `config.vm.provision "shell", inline: "ansible-playbook /vagrant/provision-files/provision.yml"`
  
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

### Optional Services

This is the current list of optional services. To use them, the playbook reference as an inline shell provisioner (see above for exmaple) to your Vagrantfile.

Service | Install Flag Name
------- | -----------------
Elasticsearch | /vagrant/provision-files/provision-elasticsearch.yml
Kibana (web front end and search tool for Elastic search) | /vagrant/provision-files/provision-kibana.yml
RabbitMQ (fast AMQP Message broker) | /vagrant/provision-files/provision-rabbitmq.yml

## License

This project is provided as-is with no licensing. Please fork and
customize as you see fit. If you would like to send pull-requests, I'm
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
