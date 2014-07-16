#selinux
turnOffSelinux:
  cmd.run:
    - name: 'setenforce 0'
    - onlyif: '[ "`getenforce`" == "Enforcing" ]'
    - user: root

/etc/sysconfig/selinux:
  file.sed:
    - before: permissive|enforcing
    - after: disabled
    - limit: ^SELINUX=

#文件打开数
/etc/security/limits.conf:
  file.append:
    - text: |
        * soft nproc 655350
        * hard nproc 655350
        * soft nofile 655350
        * hard nofile 655350

#系统参数优化
/etc/sysctl.conf:
  file.append:
    - text: |
        net.ipv4.tcp_fin_timeout = 30
        net.ipv4.tcp_keepalive_time = 300
        net.ipv4.tcp_syncookies = 1
        net.ipv4.tcp_tw_reuse = 1
        net.ipv4.tcp_tw_recycle = 1
        net.ipv4.ip_local_port_range = 5000    65000

#系统参数生效
baseOptimize_cmdSysctl:
  cmd.wait:
    - name: /sbin/sysctl -p
    - user: root
    - watch:
      - file: /etc/sysctl.conf

baseOptimize_cmdUlimit:
  cmd.wait:
    - name: /bin/bash -c "ulimit -n 655350"
    - user: root
    - watch:
      - file: /etc/security/limits.conf
