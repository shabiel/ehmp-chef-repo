#
# Cookbook Name:: jds
# Resource:: teamlist
#

action :execute do

  store = new_resource.store || new_resource.name
  store_url = "http://localhost:#{new_resource.port}/#{store}"
  data_path = "#{new_resource.data_dir}/#{store}.json"

  if !node[:jds][:jds_data][:data_bag][:teamlist].nil?
    list = data_bag_item('jds_data',node[:jds][:jds_data][:data_bag][:teamlist]).to_hash["override"]
  else
    list = JSON.parse(::File.read(data_path))
  end

  http_request "ensure cache is listening before hitting #{store}" do
    url store_url
    retries 5
    action :get
  end

  http_request "delete_#{store}" do
    url store_url
    message {}
    action :delete
    only_if { new_resource.delete_store }
  end

  http_request "put_#{store}" do
    url store_url
    message {}
    action :put
    not_if { item_exists?(store_url,"instance_start_time") }
  end

  list.each{ |item|
    facility = item['facility']
    ruby_block "check if #{item['uid']} exists" do
      block do
        puts "\nWARNING:  #{item['uid']} alread exists in #{store}.  We will skip modifying #{item['uid']}"
      end
      only_if { item_exists?("http://localhost:#{new_resource.port}/#{store}/?filter=eq(facility,#{facility})", "items") }
    end

    http_request "#{facility}_put" do
      message item.to_json
      url "http://localhost:#{new_resource.port}/#{store}"
      action :post
      not_if { item_exists?("http://localhost:#{new_resource.port}/#{store}/?filter=eq(facility,#{facility})", "items") }
    end
  }

end
