#
# Cookbook Name:: ehmp_provisioner
# Attributes:: pjds
#

default[:ehmp_provision][:pjds][:copy_files] = {}

#######################################################################################################################
# pjds specific aws configuration options
default[:ehmp_provision][:pjds][:aws][:instance_type] = "m3.medium"
default[:ehmp_provision][:pjds][:aws][:subnet] = "subnet-213b2256"
default[:ehmp_provision][:pjds][:aws][:ssh_username] = "PW      "
default[:ehmp_provision][:pjds][:aws][:ssh_keyname] = "redacted"
default[:ehmp_provision][:pjds][:aws][:ssh_key_path] = "#{ENV['HOME']}/Projects/vistacore/.chef/keys/#{node[:ehmp_provision][:pjds][:aws][:ssh_keyname]}"
#######################################################################################################################
