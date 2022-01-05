

Vagrant.configure("2") do |config|

  config.vm.define "kubemaster" do |kubemaster|
    kubemaster.vm.box = "ubuntu/focal64"
    kubemaster.vm.hostname = "kubemaster"
    kubemaster.vm.network  :private_network, ip: "192.168.10.10"
  end

  (1..3).each do |i|
    config.vm.define "kubenode#{i}" do |kubenodes|
      kubenodes.vm.box = "ubuntu/focal64"
      kubenodes.vm.hostname = "kubenode#{i}"
      kubenodes.vm.network  :private_network, ip: "192.168.10.1#{i}"

      kubenodes.vm.provider "virtualbox" do |v|  
        v.memory = 2048  
        v.cpus = 2 
      end
    end
  end

end