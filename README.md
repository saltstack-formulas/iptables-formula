iptables-formula
================

This module manages your firewall using iptables with pillar configured rules. Inbound, outbound and NAT rules are are supported, but are all optional ( just don't include an un-desired section in the pillar).

Additional options include
- delete an existing service
- delete an IP from a service or whitelist
- flush and rebuild rules ( primary use is for adding new IPs to a service with block_nomatch set to True)

Using the ability to merge pillars that contain non-overlapping parts of a pillar hierarcy, configuration can be customized per server by including a different set of pillar sls files.

Pull requests are welcome for other platforms (or other improvements of course!)

Usage
=====

All the configuration for the firewall is done via pillar (pillar.example).

Global configuration:
`pillars/firewall.sls`
```
firewall:
  enabled: True
  install: True  
  flush: False

  input:
    strict: True
    block_nomatch: False
    services:
      ssh:
        ips_allow:
          - 192.168.0.0/24
          - 10.0.2.2/32      
  output:
    strict: False
```

Allow inbound HTTP/HTTPS:
`pillars/firewall/web.sls`
```
firewall:
  input:
    services:
      http:
        ips_allow:
          - 0.0.0.0/0
      https:
        ips_allow:
          - 0.0.0.0/0
```

Restrict outbound ssh:
`pillars/firewall/ssh_out.sls`
```
firewall:
  output:
    services:
      ssh:
        block_nomatch: True
        ips_allow:
          - 192.168.1.0/24
```

Allow an entire class such as your internal network:

```
firewall:
  input:
    whitelist:
      networks:
        ips_allow:
          - 10.0.0.0/8
```

Remove existing services or individual IPs from a serivce/whitelist

```
firewall:
  input:
    services:
      ftp:
        remove: True
        ips_allow:
          - 192.168.1.0/24

    whitelist:
      networks:
        ips_allow:
          - 10.0.0.0/8
        ips_remove
          - 192.168.1.0/24

```


Notes:
 * Setting install to True will install `iptables` and `iptables-perrsistent` for you
 * Strict mode means: Deny **everything** except explicitly allowed (use with care!)
 * block_nomatch: With non-strict mode adds in a "REJECT" rule below the accept rules, otherwise other traffic to that service is still allowed. Can be defined per-service or globally, defaults to False.
 * Servicenames can be either port numbers or servicenames (e.g. ssh, zabbix-agent, http) and are available for viewing/configuring in `/etc/services`

Legacy: Format still supported
===============================
Previous versions did not support outbound rules, so input and output Jwere not included in the pillar and strict, services & whitelist were directly under firewall:  This legacy format will still work for inbound only rules.  
Example:

```
firewall:
  enabled: True
  install: True
  strict: True
    services:
      ssh:
        block_nomatch: False
        ips_allow:
          - 192.168.0.0/24
          - 10.0.2.2/32
```


Legacy: iptables.service
======================

Salt did not used to be able to merge pillars, so previously you could only define `firewall:services` in once place. With the firewall.service state and stateconf, you can define pillars for different services and include and extend the iptables.service state with the `parent` parameter to enable a default firewall configuration with special rules for different services.

`pillars/otherservice.sls`
```
otherservice:
  firewall:
    services:
      http:
        block_nomatch: False
        ips_allow:
          - 0.0.0.0/0
```

`states/otherservice.sls`
```
#!stateconf yaml . jinja

include:
  - iptables.service

extend:
  iptables.service::sls_params:
    stateconf.set:
      - parent: otherservice
```

Using iptables.nat
==================

You can use nat for interface.

```
#!stateconf yaml . jinja

# iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -j MASQUERADE

  nat:
    eth0:
      ips_allow:
        - 192.168.18.0/24
```
