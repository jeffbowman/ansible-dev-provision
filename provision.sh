echo 'KEYMAP=us' > /etc/vconsole.conf
/usr/bin/ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime

/usr/bin/loadkeys us
/usr/bin/pacman -Syy reflector --noconfirm --needed
/usr/bin/reflector -c 'United States' -p http --save /etc/pacman.d/mirrorlist

# preinstall dependencies for aur packages coming next
/usr/bin/pacman -S base-devel ansible git pacutils perl perl-libwww perl-term-ui perl-json perl-data-dump perl-lwp-protocol-https perl-term-readline-gnu perl-json-xs --noconfirm --needed

if [ ! -d /vagrant/provision-files/library ]; then
    git clone https://github.com/kewlfft/ansible-aur.git /vagrant/provision-files/library
    ln -s /vagrant/provision-files/library/aur.py /vagrant/provision-files/library/aur
fi

# install pacaur, needed for installing several packages from AUR repo
sudo -u vagrant mkdir -p /home/vagrant/aur
cd /home/vagrant/aur
sudo -u vagrant /usr/bin/curl https://aur.archlinux.org/cgit/aur.git/snapshot/trizen.tar.gz -o trizen.tar.gz
sudo -u vagrant /usr/bin/tar -zxf trizen.tar.gz && cd trizen
sudo -u vagrant /usr/bin/makepkg -sc
/usr/bin/pacman -U trizen*.xz --noconfirm --needed
#cd ../
# rm -fr trizen
# rm trizen.tar.gz

# running from inside vagrant, so full path from that perspective
# moved to Vagrantfile
# ansible-playbook /vagrant/provision-files/provision.yml --extra-vars "elasticsearch=yes kibana=yes"

# need to do this later, as a last step, this file is just a
# preliminary file and not the complete provisioning script
# /usr/bin/pacman -Scc --noconfirm
# /usr/bin/pacman-optimize
# 
# echo 'restart needed'
