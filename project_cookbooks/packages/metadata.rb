name             'packages'
maintainer       'Vistacore'
maintainer_email 'vistacore@vistacore.us'
license          'All rights reserved'
description      'disables yum and rubygems defaults'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.0.9"

#############################
# 3rd party
#############################

#############################
# wrapper_cookbook
#############################
depends "yum_wrapper", "2.0.6"
depends "rubygems_wrapper", "2.0.5"
