#
# Cookbook Name:: yum_wrapper
# Recipe:: default
#

include_recipe "yum"

yum_server = data_bag_item('servers', 'yum-managed').to_hash
node.default['yum_wrapper']['localrepo']['baseurl'] = yum_server['fqdn']

yum_repository node['yum_wrapper']['localrepo']['name'] do
  description "#{node['yum_wrapper']['localrepo']['name']} Yum Repo"
  baseurl "#{node['yum_wrapper']['localrepo']['baseurl']}"
  gpgcheck false
  priority "1"
  action :create
end

rpm_package "yum-priorities" do
	source "#{node[:nexus_url]}/nexus/content/repositories/yum-managed/fakepath/yum-plugin-priorities/#{node['yum_wrapper']['priorities_version']}/yum-plugin-priorities-#{node['yum_wrapper']['priorities_version']}.rpm"
	only_if { `rpm -qa | grep yum-plugin-priorities`.empty? }
end.run_action(:install)
