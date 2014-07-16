webconf:
  {% if grains['id'] == "10.70.32.105" %}
    - nginx_t.cntv.cn_frontend
  {% endif %}