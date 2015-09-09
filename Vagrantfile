VAGRANTFILE_API_VERSION = "2"

#system('./ubuntuproxy.sh')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provision :shell, :path => "ubuntuproxy.sh", :args => ENV['PRX']


 config.vm.network "private_network", ip: "10.2.0.10", netmask: "255.255.0.0"
 config.vm.provider :virtualbox do |vb|
 vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
 vb.memory = 4096
 vb.cpus = 2
 end

  config.vm.provision "docker" do |d|
    d.version="1.6.2"
  end

config.vm.synced_folder "../", "/box", id: "core", :nfs => true, :mount_options => ['nolock,vers=3,udp']
  
  config.vm.provision :shell, :path => "postinstall.sh" , run: "always",  privileged: "false"

  config.vm.provision :docker_compose , compose_version: "1.3.0", yml: "/box/mesos-cicd/docker-compose.yml", run: "always"

  config.vm.network :forwarded_port, guest: 6379, host: 6379
  config.vm.network :forwarded_port, guest: 5432, host: 5432
  config.vm.network :forwarded_port, guest: 5000, host: 5000
  config.vm.network :forwarded_port, guest: 5050, host: 5050
  config.vm.network :forwarded_port, guest: 8081, host: 8081
  config.vm.network :forwarded_port, guest: 8080, host: 8080



end
