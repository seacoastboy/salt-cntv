####单机多实例配置@@

##pillar名称@@
beaver:
#依据grains定义，可能造成不准确 ---待解决
{% if grains['roles'] is defined %}

#暂时解决办法，对于grains滞后的设置为不安装（兼容单机多角色设置）
##匹配grains角色@@
{% if ('beaver-apiWeb' in grains['roles']) or ('beaver-apiWeb' in grains['roles']) %}
  installed: True
{% else %}
  installed: False
{% endif %}

##定制pillar（单机多实例应角色嵌套一层以避免变量重名）@@
{% if 'beaver-apiWeb' in grains['roles'] %}
  beaver-apiWeb:
    mainConf: |
      [beaver]
      transport: redis
      redis_url: redis://10.64.0.3:6379/0
      redis_namespace: logstash:beaver
      logstash_version: 1
      
      [/usr/local/apache2/logs/api.cntv.cn-access_log_*]
      type: apiWebLog
      tags: apiWebLog
      #tags: tag1,tag2
      #add_field: fieldname1,fieldvalue1
{% endif %}

{% else %}
  installed: False
{% endif %}
