/etc/motd:
  file.managed:
    - user: root
    - group: root
    - template: jinja
    - mode: 0644
    - order: last
    - contents: |
        {% for description in pillar['description'] -%}
        {{ description -}}
        {% endfor %}-{{ grains['id'] }} is managed by CNTV SALTSTACK! 
        build time: {{ salt['cmd.run']('date "+%Y-%m-%d_%H:%m:%S"') }}
        activated roles:
        {%- for role in pillar['roles'] %}
          {{ role -}}
        {% endfor %}
