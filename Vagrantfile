# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
  end

  config.vm.network "forwarded_port", guest: 8087, host: 8087
  config.vm.network "forwarded_port", guest: 8098, host: 8098
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y vim bridge-utils tcpdump socat htop tmux jq

    tar -xzf /vagrant/riak-2.1.4-jessie-17.5.tar.gz
    chown -R vagrant riak
    sed -e '/^riak_control = / s/off/on/' \
        -e '/^listener.http.internal = / s/127.0.0.1/0.0.0.0/' \
        -e '/^listener.protobuf.internal = / s/127.0.0.1/0.0.0.0/' \
        -i riak/etc/riak.conf

    . /vagrant/damage_lib.sh
    for i in 1 2 3 4 5 6 7 8; do
        stamp_riak $i
    done
    SHELL

  config.vm.provision "shell", inline: <<-SHELL
    sed -i.bk '/this script does nothing/ s=.*=/vagrant/damage=' /etc/rc.local
    /etc/rc.local
  SHELL

end
