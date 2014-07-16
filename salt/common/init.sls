include:
  - common.cmdHistoryAudit
  - common.cntvCms
  - common.cntvSysCmds
  - common.baseOptimize
  - common.crontab
  - common.monit
  - common.motd
  - common.openLdap
  - common.rcLocal
  - common.rsync
  - common.rsyslog
  - common.sshd
  - common.salt-minion
  - common.sudoers
  - common.user
  - common.yumRepo
  #- common.zabbixAgent

/usr/local/cntv/shell:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

/usr/local/cntv/pkg:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 644
    - makedirs: True

common_pkgs:
  pkg.installed:
    - names:
{% if grains['os_family'] == "RedHat" %}
      - rsync
      - wget
      - gcc
      - make
{% endif %}
    - require:
      - file: /etc/yum.repos.d/cntvInternal.repo

#用户安全
unlockPasswd:
  cmd.run:
    - name: chattr -i /etc/passwd /etc/shadow /etc/group /etc/gshadow
    - user: root
    - order: 1

lockPasswd:
  cmd.run:
    - name: chattr +i /etc/passwd /etc/shadow /etc/group /etc/gshadow
    - user: root
    - order: last