salt-cntv
=========

## jinja2
中文文档：
http://docs.jinkan.org/docs/jinja2/templates.html

## pillar使用方法：
使用pillar规划服务器角色，在pillar文件中指定服务器角色，为states tree匹配提供基础。

	salt "*" pillar.data
```
10.70.32.105:
    ----------
    CentOS-6:
        - none
    Roles:
        - common-base
        - adminServer

10.70.63.131-logstash:
    ----------
    CentOS-5:
        - none
    Roles:
        - rsyslog
        - common-base
        - adminServer-centralControl
        - adminServer-svnServer-cluster63.228
        - adminServer-jenkinsServer
        - common-beaver-shipper
```

**master上更新后一定要同步：**

```
salt "*" saltutil.refresh_pillar
```

```
#下面两条命令分别显示master和minion存储的pillar
salt "*" pillar.items
salt "*" pillar.raw
```

匹配方法

	salt -v -I "Roles:common-base" test.ping

