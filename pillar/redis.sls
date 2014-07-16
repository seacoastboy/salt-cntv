####单机单实例配置@@

##pillar名称@@
redis:
#依据grains定义，可能造成不准确 ---待解决
{% if grains['roles'] is defined %}

#暂时解决办法，对于grains滞后的设置为不安装（兼容单机多角色设置）
##匹配grains角色@@
{% if ('logstash-redis' in grains['roles']) or ('logstash-redis' in grains['roles']) %}
  installed: True
{% else %}
  installed: False
{% endif %}

##定制pillar（单机单实例应使用相同变量名称）@@
{% if 'logstash-redis' in grains['roles'] %}
  {% set logDir = "/var/log/redis" %}
  {% set dataDir = "/var/lib/redis" %}
  {% set pidDir = "/var/run/redis" %}
  {% set port = "6379" %}
  port: {{port}}
  logDir: {{logDir}}
  dataDir: {{dataDir}}
  pidDir: {{pidDir}}
  mainConf: |
    daemonize yes
    pidfile {{pidDir}}/redis-{{port}}.pid
    port {{port}}
    timeout 60
    tcp-keepalive 0
    loglevel notice
    logfile {{logDir}}/{{port}}.log
    databases 16
    save 900 1
    save 300 10
    save 60 10000
    stop-writes-on-bgsave-error yes
    rdbcompression yes
    rdbchecksum yes
    dbfilename dump.rdb
    dir {{dataDir}}/{{port}}
    slave-serve-stale-data yes
    slave-read-only yes
    repl-disable-tcp-nodelay no
    slave-priority 100
    maxclients 65535
    maxmemory {{(grains['mem_total']/4)|round|int}}mb
    maxmemory-policy allkeys-lru
    appendonly no
    appendfsync everysec
    no-appendfsync-on-rewrite no
    auto-aof-rewrite-percentage 100
    auto-aof-rewrite-min-size 64mb
    lua-time-limit 5000
    slowlog-log-slower-than 10000
    slowlog-max-len 128
    hash-max-ziplist-entries 512
    hash-max-ziplist-value 64
    list-max-ziplist-entries 512
    list-max-ziplist-value 64
    set-max-intset-entries 512
    zset-max-ziplist-entries 128
    zset-max-ziplist-value 64
    activerehashing yes
    client-output-buffer-limit normal 0 0 0
    client-output-buffer-limit slave 256mb 64mb 60
    client-output-buffer-limit pubsub 32mb 8mb 60
    hz 10
    aof-rewrite-incremental-fsync yes
  initConf: |
    name="redis-server"
            exec="/usr/sbin/$name"
            pidfile="{{pidDir}}/redis-{{port}}.pid"
            REDIS_CONFIG="/etc/redis/{{port}}.conf"
            lockfile=/var/lock/subsys/redis-{{port}}
{% endif %}

{% else %}
  installed: False
{% endif %}
