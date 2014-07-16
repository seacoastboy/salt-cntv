service_salt-minion:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion

/etc/salt/minion:
  file.managed:
    - source: salt://common/salt-minion/minion.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - order: 1
