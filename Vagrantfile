Vagrant.require_version ">= 1.9.1"

##
# Load configuration function
def load_config()
  require 'yaml'
  require 'rbconfig'

  # Load default config
  default_config = File.expand_path(File.join(File.dirname(__FILE__), 'default.config.yml'));
  config = YAML.load_file(default_config)

  # Load override config
  override_config = File.expand_path(File.join(File.dirname(__FILE__), 'config.yml'));
  if File.exists?(override_config)
    config.merge!(YAML.load_file(override_config))
  end

  config
end

##
# Generate ansible groups from config
def ansible_groups(vconfig)

  groups = {}
  vconfig['servers'].each do |servers|
    hosts = []
    vconfig[servers].each do |server|
      hosts << server['name']
    end
    groups[servers] = hosts
  end

  groups
end

##
# Create server function
def create_server(config, vconfig, servers)

  vconfig[servers].each do |server|
    config.vm.define server['name'] do |machine|

      # Basic server config
      machine.vm.box = vconfig['vagrant_box']
      machine.vm.host_name = server['name']

      # Network config
      machine.vm.network :private_network, ip: server['ip']
      machine.vm.network :forwarded_port, guest: 22, host: server['ssh_port'], id: "ssh"

      # Map folders
      server['mapped_folders'].each do |folder|
        config.vm.synced_folder folder['src'], folder['dest'],  owner: folder['owner'], group: folder['group'], mount_options: ["dmode=775"]
      end

      # Cache packages and dependencies if vagrant-cachier plugin is present.
      if Vagrant.has_plugin?('vagrant-cachier')
        config.cache.scope = :box
        config.cache.auto_detect = false
        config.cache.enable :apt
        config.cache.enable :composer
      end

      # Provision machines
      machine.vm.provision :ansible do |ansible|
        ansible.playbook = "ansible/site.yml"
        ansible.groups = ansible_groups(vconfig)
      end
    end
  end
end

##
# Configure the virtual machines
Vagrant.configure('2') do |config|

  vconfig = load_config
  ansible_groups(vconfig)

  # VirtualBox config
  config.vm.provider :virtualbox do |box|
    box.memory = vconfig['memory']
    box.cpus = vconfig['cpus']
    box.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    box.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Vagrant hostmanager plugin config
  if Vagrant.has_plugin?('vagrant-hostmanager')
    config.hostmanager.enabled = true
    config.hostmanager.manage_guest = true
  end

  # Create servers
  vconfig['servers'].each do |servers|
    create_server(config, vconfig, servers)
  end

end
