# ansible-dev-provision
ansible roles for provisioning vagrant development environment.

Steps to use:

* vagrant init ogarcia/archlinux-x64
* update the Vagrant file, mount the .m2/repository directory
  `config.vm.synced_folder "/$HOME/.m2/repository", "/home/vagrant/.m2/repository", owner: "vagrant", group: "users"`
* optionally mount the "/vagrant" as "$HOME/git" in the vm
  `config.vm.synced_folder "/path/to/Vagrantfile" "/home/vagrant/git"`
* use the following:
  - `vb.gui = true`
  - `vb.memory = "8192"` (if possible, adjust as necessary)
  - `vb.cpus = "4"`      (if possible, adjust as necessary)
  - `vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]`
  - `vb.customize ["modifyvm", :id, "--vram", "128"]`
* setup the provisioning script
  `config.vm.provision "shell", path: "provision-files/provision.sh"`
* `git clone git@github.com/jeffbowman/ansible-dev-provision.git provision-files`
* copy files from Mega.nz into the provision-files directory
  - AnypointStudio.tar.gz
  - AnypointStudio.desktop
  - KeePassHttp.plgx
  - settings.xml
  - SwapCaps.desktop
  - wallpapers.zip
* if these files aren't available, update the roles to not use them (see the user-config role)
* `vagrant up --provision`

Assuming everything goes well and there are no errors, you will need
to restart vagrant, you will need to login once with a password which
will allow setting up XFCE4 the first time. One more restart of the
vagrant machine and you should automatically login.
