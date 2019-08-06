# -*- coding: utf-8 -*-
# vim: ft=yaml
---
firewall:
  install: true
  enabled: true
  strict: true
  ipv6: false
  ## To manage the firewall writing rules instead of services, check
  ## the `pillar.tables.example` for examples
  services:
    ssh:
      block_nomatch: true
      ips_allow:
        - 10.0.0.0/8
        - 172.16.0.0/12
        - 192.168.0.0/16
    http:
      block_nomatch: false
      protos:
        - udp
        - tcp
    snmp:
      block_nomatch: false
      protos:
        - udp
        - tcp
      interfaces:
        - eth0

  whitelist:
    networks:
      ips_allow:
        - 10.0.0.0/8

  # yamllint disable rule:line-length
  # Support nat (ipv4 only)
  # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 10.20.0.2 -j MASQUERADE
  # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 172.31.0.2 -j MASQUERADE
  # yamllint enable rule:line-length
  nat:
    eth0:
      rules:
        '192.168.18.0/24':
          - 10.20.0.2
