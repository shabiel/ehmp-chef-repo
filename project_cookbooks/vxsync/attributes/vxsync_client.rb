#
# Cookbook Name:: vxsync
# Attributes:: vxsync_client
#

default[:vxsync][:client][:home_dir] = '/opt/vxsync_client'
default[:vxsync][:client][:service_name] = 'vxsync_client'
default[:vxsync][:client][:log_directory] = "/var/log/vxsync"
default[:vxsync][:client][:log_prefix] = "vxsync"
default[:vxsync][:client][:log_ext] = ".log"
default[:vxsync][:client][:log_pattern] = "#{node[:vxsync][:client][:log_directory]}/#{node[:vxsync][:client][:log_prefix]}#{node[:vxsync][:client][:log_ext]}"
default[:vxsync][:client][:config_file] = "#{node[:vxsync][:client][:home_dir]}/worker-config.json"
default[:vxsync][:client][:data_dir] = '/var/vxsync'
default[:vxsync][:client][:beanstalk_dir] = '/var/vxsync/beanstalk_client'
default[:vxsync][:client][:documents_dir] = "#{node[:vxsync][:client][:data_dir]}/documents"
default[:vxsync][:client][:persistence_dir] = "#{node[:vxsync][:client][:home_dir]}/data"
default[:vxsync][:client][:bluepill_log_dir] = "#{node[:vxsync][:client][:log_directory]}/bluepill"

default[:vxsync][:client][:beanstalk_processes] = {
  :jobrepo_client => {
    :template => "job_repo.sh.erb",
    :config => {
      :port => 5000,
      :max_file_size => node[:vxsync][:max_file_size]
    }
  }
}

default[:vxsync][:client][:processes] = {
  :subscriber_vistahdr => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "vistahdr"
    },
  },
  :subscriber_storage_client => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "storage"
    },
    :number_of_copies => 3
  },
  :subscriber_primary => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "primary"
    }
  },
  :subscriber_jmeadows => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "jmeadows"
    }
  },
  :subscriber_hdr => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "hdr"
    }
  },
  :subscriber_vler => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "vler"
    }
  },
  :subscriber_pgd => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "pgd"
    }
  },
  :subscriber_document => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "document"
    }
  },
  :subscriber_enrichment_client => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "enrichment"
    }
  },
  :subscriber_publish_client => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "publish"
    }
  },
  :subscriber_error_client => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "error"
    }
  },
  :subscriber_vistahdr => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "vistahdr"
    }
  },
  :subscriber_resync => {
    :template => "subscriber_host.sh.erb",
    :config => {
      :profile => "resync"
    }
  },
  :error_processor_client => {
    :template => "error_processor_host.sh.erb",
    :config => {
    }
  },
  :'sync-request-endpoint' => {
    :template => "sync_request_endpoint.sh.erb",
    :config => {
      :port => 8080
    }
  },
  :'writeback-endpoint' => {
    :template => "writeback_endpoint.sh.erb",
    :config => {
      :port => 9090
    }
  },
  :unsync => {
    :template => "unsync.sh.erb",
    :config => {
      :port => 8091
    }
  },
  :'admin-endpoint-client' => {
    :template => "admin_endpoint.sh.erb",
    :config => {
      :port => 9999
    }
  }
}
