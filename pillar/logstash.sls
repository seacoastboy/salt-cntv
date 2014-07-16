####单机多实例配置@@

##pillar名称@@
logstash:
#依据grains定义，可能造成不准确 ---待解决
{% if grains['roles'] is defined %}

#暂时解决办法，对于grains滞后的设置为不安装（兼容单机多角色设置）
##匹配grains角色@@
{% if ('logstash-indexer' in grains['roles']) or ('logstash-beaverIndexer' in grains['roles']) %}
  installed: True
{% else %}
  installed: False
{% endif %}

##定制pillar（单机多实例应角色嵌套一层以避免变量重名）@@
{% if 'logstash-indexer' in grains['roles'] %}
  logstash-indexer:
    redisIp: "10.64.0.1"
    redisPort: "6379"
    initConf: |
      START=true
      NICE=0
      USER=logstash
      OPEN_FILES=65535
      FILTER_THREADS=4
      CONF_DIR=/opt/logstash/etc/logstash-indexer.conf
      LS_JAVA_OPTS="-Xmx{{(grains['mem_total']*0.3)|round|int}}m -Djava.io.tmpdir=$LS_HOME/tmp"
{% endif %}
{% if 'logstash-beaverIndexer' in grains['roles'] %}
  logstash-beaverIndexer:
    redisIp: "10.64.0.3"
    redisPort: "6379"
    initConf: |
      START=true
      NICE=0
      USER=logstash
      OPEN_FILES=65535
      FILTER_THREADS=4
      CONF_DIR=/opt/logstash/etc/logstash-beaverIndexer.conf
      LS_JAVA_OPTS="-Xmx{{(grains['mem_total']*0.3)|round|int}}m -Djava.io.tmpdir=$LS_HOME/tmp"
{% endif %}

{% else %}
  installed: False
{% endif %}
