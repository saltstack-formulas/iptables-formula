firewall-formula
========

This module manages your firewall using iptables with pillar configured rules. 
Thanks to the nature of Pillars it is possible to write global and local settings (e.g. enable globally, configure locally)

Pull requests are welcome for other platforms (or other improvements ofcourse!)

Usage
=====

All the configuration for the firewall is done via pillar (pillar.example).

Enable globally:
`pillars/firewall.sls`
```
firewall:
  enabled: True
  install: True  
  strict: True
```

Allow SSH:
`pillars/firewall/ssh.sls`
```
firewall:
  services:
    ssh:
      block_nomatch: False
      ips_allow:
        - 192.168.0.0/24
        - 10.0.2.2/32
```

Salt combines both and effectively enables your firewall and applies the rules.

Notes:
 * Setting install to True will install `iptables` and `iptables-perrsistent` for you
 * Strict mode means: Deny **everything** except explicitly allowed (use with care!)
 * block_nomatch: With non-strict mode adds in a "REJECT" rule below the accept rules, otherwise other traffic to that service is still allowed. Can be defined per-service or globally, defaults to False.
 * Servicenames can be either port numbers or servicenames (e.g. ssh, zabbix-agent, http) and are available for viewing/configuring in `/etc/services`
