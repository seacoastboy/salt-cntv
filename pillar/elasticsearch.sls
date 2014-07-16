####单机单实例配置@@

##pillar名称@@
elasticsearch:
#依据grains定义，可能造成不准确 ---待解决
{% if grains['roles'] is defined %}

#暂时解决办法，对于grains滞后的设置为不安装（兼容单机多角色设置）
##匹配grains角色@@
{% if ('logstash-esNode' in grains['roles']) or ('logstash-esSearchNode' in grains['roles']) %}
  installed: True
{% else %}
  installed: False
{% endif %}

##定制pillar（单机单实例应使用相同变量名称）@@
{% if 'logstash-esNode' in grains['roles'] %}
  pkg: "salt://elasticsearch/files/elasticsearch-0.90.12.noarch.rpm"
  plugins: "salt://elasticsearch/files/plugins.tgz"
  dataDir: "/syslog/ESdata"
  minMem: "ES_MIN_MEM={{ (grains['mem_total'] * 0.6)|round|int }}m"
  maxMem: "ES_MAX_MEM={{ (grains['mem_total'] * 0.8)|round|int }}m"
  mainConf: |
    cluster.name: elasticsearch-test-cluster
    node.name: node-{{ grains['id'] }}
    
    index.number_of_shards: 5
    index.number_of_replicas: 2
    path.data: /syslog/ESdata
    bootstrap.mlockall: true
    
    gateway.recover_after_nodes: 1
    gateway.recover_after_time: 5m
    gateway.expected_nodes: 2
    
    cluster.routing.allocation.node_initial_primaries_recoveries: 4
    cluster.routing.allocation.node_concurrent_recoveries: 4
    indices.recovery.max_bytes_per_sec: 400mb
    indices.recovery.concurrent_streams: 5
    indices.memory.index_buffer_size: 50%
    
    discovery.zen.ping.timeout: 20s
    discovery.zen.ping.unicast.hosts: ["10.64.1.174", "10.64.1.175", "10.64.1.176", "10.64.1.177"]
    
    index.cache.field.max_size: 50000
    index.cache.field.expire: 10m
    index.cache.field.type: soft
    
    marvel.agent.exporter.es.hosts: ["10.7.3.121:9200","10.7.3.122:9200"]
    index.translog.flush_threshold_ops: 50000
    
    # Search thread pool
    threadpool.search.type: fixed
    threadpool.search.size: 20
    threadpool.search.queue_size: 100
    
    # Index thread pool
    threadpool.index.type: fixed
    threadpool.index.size: 60
    threadpool.index.queue_size: 200
{% elif 'logstash-esSearchNode' in grains['roles'] %}
  pkg: "salt://elasticsearch/files/elasticsearch-0.90.12.noarch.rpm"
  plugins: "salt://elasticsearch/files/plugins.tgz"
  dataDir: "/syslog/ESdata"
  minMem: "ES_MIN_MEM={{ (grains['mem_total'] * 0.6)|round|int }}m"
  maxMem: "ES_MAX_MEM={{ (grains['mem_total'] * 0.8)|round|int }}m"
  mainConf: |
    cluster.name: elasticsearch-test-cluster
    node.name: "node-{{ grains['id'] }}-search"
    node.master: false
    node.data: false
    index.number_of_shards: 5
    index.number_of_replicas: 1
    path.data: /syslog/ESdata
    bootstrap.mlockall: true
    gateway.recover_after_nodes: 1
    gateway.recover_after_time: 5m
    gateway.expected_nodes: 2
    cluster.routing.allocation.node_initial_primaries_recoveries: 4
    cluster.routing.allocation.node_concurrent_recoveries: 4
    indices.recovery.max_bytes_per_sec: 400mb
    indices.recovery.concurrent_streams: 5
    discovery.zen.ping.unicast.hosts: ["10.64.0.2", "10.64.0.4"]
    marvel.agent.exporter.es.hosts: ["10.7.3.121:9200","10.7.3.122:9200"]
{% endif %}

{% else %}
  installed: False
{% endif %}
