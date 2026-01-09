Vagrant.configure("2") do |config|

  # Ubuntu OS
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "jenkins-server"

  # Fixed Private IP
  config.vm.network "private_network", ip: "192.168.56.10"

  # Port Forwarding (Host → VM)
  config.vm.network "forwarded_port", guest: 8080, host: 8080   # Jenkins UI
  config.vm.network "forwarded_port", guest: 22, host: 2222     # SSH
  config.vm.network "forwarded_port", guest: 80, host: 8081     # HTTP
  config.vm.network "forwarded_port", guest: 443, host: 8443    # HTTPS
  config.vm.network "forwarded_port", guest: 3000, host: 3000   # App testing
  config.vm.network "forwarded_port", guest: 5000, host: 5000   # Docker registry
  config.vm.network "forwarded_port", guest: 9000, host: 9000   # SonarQube

  # VirtualBox Configuration
  config.vm.provider "virtualbox" do |vb|
    vb.name = "jenkins-ubuntu"
    vb.memory = "4096"
    vb.cpus = 2
  end
end
