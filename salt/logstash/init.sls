#防止grains["role"]和pillar["role"]不同步，加一层判断
##判断是否安装@@
{% if pillar['logstash']['installed'] == True %}

####单机多实例公共配置@@

##软件包安装@@
logstash_pkg_java-1.7:
  pkg.installed:
    - name: java-1.7.0-openjdk-devel
logstash_pkg:
  pkg.installed:
    - name: logstash
    - sources:
      - logstash: salt://logstash/files/logstash-1.3.3-1_centos.noarch.rpm
    - skip_verify: True
    - require:
      - pkg: logstash_pkg_java-1.7


##创建并设置目录权限@@
{% for path in '/opt/logstash', '/opt/logstash/tmp', '/var/log/logstash' %}
{{ path }}:
  file.directory:
    - makedirs: True
    - user: logstash
    - group: root
    - dir_mode: 0755
    - recurse:
      - user
      - group
      - mode
    - require:
      - pkg: logstash_pkg
{% endfor %}

##拷贝files目录下文件@@
/opt/logstash/etc:
  file.recurse:
    - source: salt://logstash/files/etc
    - user: root
    - group: root
    - file_mode: 0644
    - dir_mode: 0755
    - makedirs: True

####单机多实例非公共配置循环@@

{% for role in pillar['roles'] %}
{% if pillar['logstash'][role] is defined %}
/opt/logstash/etc/{{role}}.conf:
  file.managed:
    - source: salt://logstash/files/{{role}}.conf.jinja
    - template: jinja
    - user: logstash
    - group: root
    - mode: 0755
    - require:
      - file: /opt/logstash/etc
/etc/init.d/{{ role }}:
  file.managed:
    - source: salt://logstash/files/logstash.init.d.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 0755
    - context:
      role: {{role}}
/etc/sysconfig/{{ role }}:
  file.managed:
    - user: root
    - group: root
    - file_mode: 0644
    - contents_pillar: logstash:{{role}}:initConf
    - require:
      - pkg: logstash_pkg
logstash_{{role}}_service:
  service.running:
    - name: {{ role }}
    - enable: True
    - timeout: 15
    - watch:
      - file: /opt/logstash/etc/{{role}}.conf
{% endif %}
{% endfor %}

{% endif %}