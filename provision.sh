echo 'KEYMAP=us' > /etc/vconsole.conf
/usr/bin/ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

/usr/bin/loadkeys us
/usr/bin/pacman -Syy reflector --noconfirm --needed
/usr/bin/reflector -c 'United States' -p http --save /etc/pacman.d/mirrorlist

# preinstall dependencies for aur packages coming next
/usr/bin/pacman -S ansible yajl perl-error git expac nodejs --noconfirm --needed

if [ ! -d /vagrant/provision-files/library ]; then
    git clone https://git.project-insanity.org/onny/ansible-pacaur.git /vagrant/provision-files/library
    mv /vagrant/provision-files/library/packer /vagrant/provision-files/library/pacaur
fi

# install pacaur, needed for installing several packages from AUR repo
sudo -u vagrant mkdir -p /home/vagrant/aur
cd /home/vagrant/aur
sudo -u vagrant /usr/bin/curl https://aur.archlinux.org/cgit/aur.git/snapshot/cower-git.tar.gz -o cower.tar.gz
sudo -u vagrant /usr/bin/curl https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz -o pacaur.tar.gz
sudo -u vagrant /usr/bin/tar -zxf cower.tar.gz && cd cower-git
sudo -u vagrant /usr/bin/makepkg -sc
/usr/bin/pacman -U cower*.xz --noconfirm --needed
cd ../
rm -fr cower-git
sudo -u vagrant tar -zxf pacaur.tar.gz && cd pacaur
sudo -u vagrant /usr/bin/makepkg -sc
/usr/bin/pacman -U pacaur*.xz --noconfirm --needed
cd ../
rm -fr pacaur

# running from inside vagrant, so full path from that perspective
# moved to Vagrantfile
# ansible-playbook /vagrant/provision-files/provision.yml --extra-vars "elasticsearch=yes kibana=yes"

# need to do this later, as a last step, this file is just a
# preliminary file and not the complete provisioning script
# /usr/bin/pacman -Scc --noconfirm
# /usr/bin/pacman-optimize
# 
# echo 'restart needed'
