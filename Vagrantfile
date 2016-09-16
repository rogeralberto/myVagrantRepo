Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.box_version = "1.1.0"
  config.vm.box_url = "hashicorp/precise64"
  config.vm.provision :shell, path: "install.sh"
  config.vm.network :forwarded_port, guest:80, host:8080
end
