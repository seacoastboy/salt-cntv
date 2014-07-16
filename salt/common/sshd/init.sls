/etc/ssh/sshd_config:
  file.managed:
    - source: salt://common/sshd/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 0400