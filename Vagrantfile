# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update && apt-get install -y vim bridge-utils tcpdump
    tar -xzf /vagrant/riak-2.1.4-jessie-17.5.tar.gz
    chown -R vagrant riak
    sed -e '/^riak_control/ s/off/on/' \
        -e '/^listener.http.internal/ s/127.0.0.1/0.0.0.0/' \
        -i riak/etc/riak.conf
    SHELL

  config.vm.provision "shell", inline: <<-SHELL
    sudo brctl addbr br0
    sudo ip addr add 10.99.88.254/24 dev br0
    sudo ip link set br0 up
  SHELL
  config.vm.provision :shell, :path => "netns", :args => "1"
  config.vm.provision :shell, :path => "netns", :args => "2"

end
