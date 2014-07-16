base:
  'roles:base':
    - match: pillar
    - common
  'roles:admin-svnServer':
    - match: pillar
    - project.cntvSvnServer

  'I@roles:logstash-esNode':
    - match: compound
    - elasticsearch

  'I@roles:logstash-esSearchNode':
    - match: compound
    - elasticsearch
  
  'I@roles:logstash-indexer':
    - match: compound
    - logstash
  
  'I@roles:logstash-beaverIndexer':
    - match: compound
    - logstash

  'I@roles:yumRepo':
    - match: compound
    - project.yumRepo

  'I@roles:logstash-redis':
    - match: compound
    - redis

  'I@roles:beaver-apiWeb':
    - match: compound
    - beaver

#  'I@roles:admin-svnServer or I@roles:admin-svnServer-cluster63.228':
#    - match: compound