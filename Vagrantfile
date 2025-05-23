machine_name = "appserver.test"
ip_address = "192.168.56.0"
vm_box = "bento/ubuntu-18.04"

Vagrant.configure("2") do |config|
  # Machine name for Vagrant, and machine type
  config.vm.define machine_name
  config.vm.box = vm_box

  # Machine name for virtualbox, and RAM size
  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--name", "#{machine_name}-docker-AEGEE",
      "--memory", "2048",
    ]
  end

  # Avoids wasting time on virtualbox guest additions mismatch
  config.vbguest.auto_update = false

  ## Network configurations ##
  config.vm.hostname = machine_name
  config.vm.network :private_network, ip: ip_address

  ## Provisioning scripts ##

  # Fix line endings for scripts
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update -qq
    apt-get install -qq -y dos2unix build-essential nodejs npm
    cd /vagrant
    dos2unix *.sh
    dos2unix scripts-vagrant_provision/*.sh
  SHELL

  # Nice-to-have prompt and completion
  config.vm.provision "shell", inline: <<-SHELL
    dos2unix /vagrant/scripts-vagrant_provision/bashrc
    cp /vagrant/scripts-vagrant_provision/bashrc /home/vagrant/.bashrc
    chown vagrant:vagrant /home/vagrant/.bashrc
  SHELL

  # Ansible playbook
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "scripts-vagrant_provision/provision.yml"
    ansible.compatibility_mode = "2.0"
    ansible.extra_vars = "scripts-vagrant_provision/local.yml"
    #ansible.tags = "docker"
  end

  # Provision Docker orchestration (set to always run)
  config.vm.provision "shell", path: "scripts-vagrant_provision/orchestrate_docker.sh", run: "always"

  # Post up message
  config.vm.post_up_message = "[FINALLY!] Setup is complete, open your browser to http://my.#{machine_name} (did you configure /etc/hosts via start.sh or manually?)"

  ## Deprovisioning scripts ##
  config.trigger.before :destroy do |trigger|
    trigger.warn = "Removing .init to avoid Docker network mismatch"
    trigger.run_remote = { inline: "rm /vagrant/.init 2>/dev/null || echo 'file already gone'" }
  end

end
