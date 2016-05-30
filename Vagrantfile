# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"

  config.vm.network "forwarded_port", guest: 8097, host: 8097
  config.vm.network "forwarded_port", guest: 8098, host: 8098
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update && apt-get install -y vim bridge-utils tcpdump socat
    tar -xzf /vagrant/riak-2.1.4-jessie-17.5.tar.gz
    chown -R vagrant riak
    sed -e '/^riak_control = / s/off/on/' \
        -e '/^listener.http.internal = / s/127.0.0.1/0.0.0.0/' \
        -i riak/etc/riak.conf
    for i in 1 2 3; do
        cp -a riak riak${i}
        sed -i "/^nodename =/ s/127.0.0.1/10.99.88.${i}/" riak${i}/etc/riak.conf
    done
    SHELL

  config.vm.provision "shell", inline: <<-SHELL
    sed -i '/this script does nothing/ s=.*=/vagrant/riakrc 2>\\&1 | tee /riakrc.log=' \
        /etc/rc.local
    /etc/rc.local
  SHELL

end
