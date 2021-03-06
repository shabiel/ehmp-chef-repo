#
# Cookbook Name:: rdk_provision
# Recipe:: rdk
#

chef_gem "chef-provisioning-ssh"
require 'chef/provisioning/ssh_driver'

####################################################### Shared Folders #########################################################
if ENV['DEV_DEPLOY']
  node.default[:rdk_provision][:rdk][:vagrant][:shared_folders].push(
    {
      :host_path => "#{ENV['HOME']}/Projects/vistacore/rdk/product/production/rdk",
      :guest_path => "/opt/rdk",
      :create => true
    },
    {
       :host_path => "#{ENV['HOME']}/Projects/vistacore/rdk/product/production/rdk/ccow",
       :guest_path => "/opt/ccow",
       :create => true
    }
  )
end
######################################################## Shared Folders ########################################################

version = ENV['RDK_VERSION']

# deploy default of one machine named "rdk" if rdk config doesn't exist, get servers from config if config does exist
rdk_machines = if node[:rdk_config].nil? then ["rdk"] else node[:rdk_config].keys end

machine_ident = ENV['RDK_IDENT'] || "rdk"
db_item = ENV['RDK_DB_ITEM'] || ENV['RDK_IDENT']

unless db_item.nil?
  db_attributes = Chef::EncryptedDataBagItem.load("rdk_env", db_item, node[:common][:data_bag_string])
  node.override[:rdk_provision] = Chef::Mixin::DeepMerge.hash_only_merge(node[:rdk_provision], db_attributes["rdk_provision"]) unless db_attributes["rdk_provision"].nil?
end
boot_options = node[:rdk_provision][:rdk]["#{node[:machine][:driver]}".to_sym]
node.default[:rdk_provision][:rdk][:copy_files].merge!(node[:machine][:copy_files])

machine_deps = parse_dependency_versions "machine"
rdk_deps = parse_dependency_versions "rdk_provision"

r_list = []
r_list << "recipe[packages::enable_internal_sources@#{machine_deps["packages"]}]"
r_list << "recipe[packages::disable_external_sources@#{machine_deps["packages"]}]" unless node[:machine][:allow_web_access]
r_list << "recipe[role_cookbook::#{node[:machine][:driver]}@#{machine_deps["role_cookbook"]}]"
r_list << "role[resource_server]"
r_list << "recipe[rdk::clear_logs@#{rdk_deps["rdk"]}]" if node[:machine][:driver] == "aws"
r_list << "recipe[rdk@#{rdk_deps["rdk"]}]"
r_list << "recipe[packages::upload@#{machine_deps["packages"]}]" if node[:machine][:cache_upload]
r_list << "recipe[packages::remove_localrepo@#{machine_deps["packages"]}]" if node[:machine][:driver] == "ssh"

machine_boot "boot #{machine_ident} machine to the #{node[:machine][:driver]} environment" do
  machine_name machine_ident
  boot_options boot_options
  driver node[:machine][:driver]
  action node[:machine][:driver]
  only_if { node[:machine][:production_settings][machine_ident.to_sym].nil? }
end

# if the driver is 'vagrant', append -node- after the machine identify and before the stack name; else use only machine-stack
machine_name = node[:machine][:driver] == "vagrant" ? "#{machine_ident}-#{node[:machine][:stack]}-node" : "#{machine_ident}-#{node[:machine][:stack]}"
machine machine_name do
  driver "ssh"
  converge node[:machine][:converge]
  machine_options lazy {
    {
      :transport_options => {
        :ip_address => node[:machine][:production_settings][machine_ident.to_sym][:ip],
        :username => node[:machine][:production_settings][machine_ident.to_sym][:ssh_username],
        :ssh_options => {
          :keys => [
            node[:machine][:production_settings][machine_ident.to_sym][:ssh_key]
          ],
        },
        :options => {
          :prefix => 'sudo ',
        }
      },
      :convergence_options => node[:machine][:convergence_options]
    }
  }
  attributes(
    stack: node[:machine][:stack],
    allow_ldap_access: node[:machine][:allow_ldap_access],
    nexus_url: node[:common][:nexus_url],
    data_bag_string: node[:common][:data_bag_string],
    dev_deploy: ENV['DEV_DEPLOY'] == "true" ? true : false,
    using_vagrant: node[:machine][:driver] == "vagrant",
    rdk: {
      profile: db_item,
      source: artifact_url(node[:rdk_provision][:artifacts][:rdk]),
      version: ENV['RDK_VERSION']
    },
    beats: {
      logging: node[:machine][:logging]
  }
  )
  files lazy { node[:rdk_provision][:rdk][:copy_files] }
  chef_environment node[:machine][:environment]
  run_list r_list
  action node[:machine][:action]
end

chef_node machine_name do
  action :delete
  only_if {
    node[:machine][:action].eql?("destroy") && node[:machine][:driver].eql?("vagrant")
  }
end
