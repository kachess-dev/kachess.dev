Vagrant.configure("2") do |config|
  # Dynamically set the machine name to the name of the current directory
  current_dir_name = File.basename(Dir.getwd)
  config.vm.define current_dir_name do |docker_vm|
    docker_vm.vm.hostname = "ubuntu"

    docker_vm.vm.provider :docker do |docker, override|
      override.vm.box = nil
      docker.git_repo = "git@github.com:calef/vagrant-docker-provider-ubuntu-latest.git"
      docker.remains_running = true
      docker.has_ssh = true
      docker.privileged = true
      docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
      docker.create_args = ["--cgroupns=host"]
    end
    config.vm.network "forwarded_port", guest: 4000, host: 4000
    config.vm.provision "file", source: "~/.ssh", destination: "/home/vagrant/.ssh_temp"
    docker_vm.vm.provision "shell", inline: <<-SHELL
      # Add a provisioner to change to a specific subdirectory of /vagrant upon login
      # The subdirectory matches the name of the current directory on the host machine
      echo 'cd /vagrant' >> /home/vagrant/.bashrc

      # update the packages
      sudo apt-get update
      sudo apt-get install -y git

      # copy the keys
      mkdir -p /home/vagrant/.ssh
      # Copy all files from .ssh_temp to .ssh directory
      cp -r /home/vagrant/.ssh_temp/* /home/vagrant/.ssh/
      # Remove temporary directory
      rm -rf /home/vagrant/.ssh_temp
      # Set the correct permissions for the .ssh directory and its contents
      chmod 700 /home/vagrant/.ssh
      chmod 600 /home/vagrant/.ssh/*
      # Ensure the authorized_keys file also has correct permissions in case it exists
      chmod 644 /home/vagrant/.ssh/authorized_keys
      # Change ownership of all the files in .ssh to vagrant user
      chown -R vagrant:vagrant /home/vagrant/.ssh
    SHELL
  end
end
