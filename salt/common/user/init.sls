#用户
{% for username in pillar['myShadow']['system'] %}
{% set user = pillar['myShadow']['system'][username] %}
{% for role in user.roles %}
{% if role in pillar["roles"] %}
{{username}}:
  user.present:
    - home: {{user.home}}
    {% if 'uid' in user %}
    - uid: {{user.uid}}
    {% endif %}
    {% if 'shell' in user %}
    - shell: {{user.shell}}
    {% endif %}
    {% if 'groups' in user %}
    - groups: {{user.groups}}
    {% endif %}
    - gid_from_name: true
{% if 'sshKey_pub' in user %}
{{user.home}}/.ssh/authorized_keys:
  file.managed:
    - user: {{username}}
    - group: {{username}}
    - file_mode: 600
    - dir_mode: 700
    - makedirs: True
    - contents_pillar: myShadow:system:{{username}}:sshKey_pub
    - require:
      - user: {{username}}
{% endif %}
{% endif %}
{% endfor %}
{% endfor %}

#中央服务器复制root的sshkey
{% if "admin-centralControl" in pillar['roles'] %}
/root/.ssh/id_rsa:
  file.managed:
    - user: root
    - group: root
    - file_mode: 600
    - dir_mode: 700
    - makedirs: True
    - contents_pillar: myShadow:system:root:sshKey_priv
    - require:
      - user: root
/root/.ssh/id_rsa.pub:
  file.managed:
    - user: root
    - group: root
    - file_mode: 0644
    - dir_mode: 700
    - makedirs: True
    - contents_pillar: myShadow:system:root:sshKey_pub
    - require:
      - user: root
{% endif %}