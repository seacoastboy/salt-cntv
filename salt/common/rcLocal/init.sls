/etc/rc.local:
  file.append:
    - text: |
        /usr/bin/rsyncCntvCms --daemon --config=/etc/cntvCms/rsyncd.conf --port 7878
{%- if "admin-svnServer" in pillar["roles"] %}
        /usr/bin/rsync --daemon --config=/etc/rsyncd_salt.conf --port 874
{%- endif %}
