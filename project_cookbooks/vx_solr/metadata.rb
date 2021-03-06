name             'vx_solr'
maintainer       'Vistacore - Team Milky Way'
maintainer_email 'team-milkyway@vistacore.us'
license          'MIT'
description      'Installs the solr search engine.'
long_description 'See README.md'
version          "2.0.30"

supports 'redhat'
supports 'centos'

depends "common", "2.0.12"
depends "chef-rewind"

#############################
# 3rd party
#############################

#############################
# wrapper_cookbook
#############################
depends "solr_wrapper", "2.0.6"
depends "zookeeper-cluster_wrapper", "2.0.3"
