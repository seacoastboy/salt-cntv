/var/spool/cron/autoOps:
  file.managed:
    - source: salt://common/crontab/autoOps
    - user: autoOps
    - group: root
    - mode: 0600
    - require:
      - user: autoOps

{% for name in "logstash-esNode-crontab", "yumRepo" %}
{% if name in pillar["roles"] %}
{{ name }}_crontab:
  file.blockreplace:
    - name: /etc/crontab
    - marker_start: "## {{ name }} start ##"
    - marker_end: "## {{ name }} end ## "
    - content: |
        {%- if name == "logstash-esNode-crontab" %}
        0 1 * * * root /usr/local/cntv/elasticsearchDayJob.sh
        {%- elif name == "yumRepo" %}
        0 1 * * * root /usr/local/cntv/yumSync/rsync.sh
        */10 * * * * root /usr/local/cntv/yumSync/cntvInternalRepoSync.sh
        {%- endif %}
    - append_if_not_found: True
    - backup: '.bak'
{% endif %}
{% endfor %}
