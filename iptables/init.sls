# -*- coding: utf-8 -*-
# vim: ft=sls

# Firewall management module
{%- from "iptables/map.jinja" import firewall with context %}
{%- set install = firewall.install %}
{%- set strict_mode = firewall.strict %}
{%- set global_block_nomatch = firewall.block_nomatch %}
{#- TODO: Ideally, this Fedora 34 fix should be provided from `osfingermap.yaml` but that isn't available #}
{#-       Resolve this when the new `map.jinja` is made available for this formula #}
{%- set packages = ['iptables-compat'] if grains.get('osfinger', '') == 'Fedora-34' else firewall.pkgs %}
{%- set ipv4 = 'IPv4' %}
{%- set ipv6 = 'IPv6' %}
{%- set protocols = [ipv4] %}
{%- if firewall.get('ipv6', False) %}
{%-   do protocols.append(ipv6) %}
{%- endif %}
{%- set suffixes = {ipv4: '', ipv6: '_ipv6'} %}

{%- if firewall.enabled %}
{%-   if install %}
# Install required packages for firewalling
iptables_packages:
  pkg.installed:
    - pkgs:
{%-     for pkg in packages %}
      - {{ pkg }}
{%-     endfor %}
{%-   endif %}

{%-   if strict_mode %}
# If the firewall is set to strict mode, we'll need to allow some
# that always need access to anything
{%-     for protocol in protocols %}
iptables_allow_localhost{{ suffixes[protocol] }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
{%-       if protocol == ipv4 %}
    - source: 127.0.0.1
{%-       else %}
    - source: ::1
    - family: ipv6
{%-       endif %}
    - save: True

# Allow related/established sessions
iptables_allow_established{{ suffixes[protocol] }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: conntrack
    - ctstate: 'RELATED,ESTABLISHED'
{%-       if protocol == ipv6 %}
    - family: ipv6
{%-       endif %}
    - save: True

# Set the policy to deny everything unless defined
enable_reject_policy{{ suffixes[protocol] }}:
  iptables.set_policy:
    - table: filter
    - chain: INPUT
    - policy: DROP
{%-       if protocol == ipv6 %}
    - family: ipv6
{%-       endif %}
    - save: True
    - require:
      - iptables: iptables_allow_localhost{{ suffixes[protocol] }}
      - iptables: iptables_allow_established{{ suffixes[protocol] }}
{%-     endfor %}
{%-   endif %}

{%-   if not firewall.use_tables %}
# Generate ipsets for all services that we have information about
{%-     for protocol in protocols %}
{%-       for service_name, service_details in firewall.get('services' + suffixes[protocol], {}).items() %}
{%-         set block_nomatch = service_details.get('block_nomatch', False) %}
{%-         set interfaces = service_details.get('interfaces','') %}
{%-         set protos = service_details.get('protos',['tcp']) %}
{%-         if service_details.get('comment', False) %}
{%-           set comment = '- comment: ' + service_details.get('comment') %}
{%-         else %}
{%-           set comment = '' %}
{%-         endif %}

# Allow rules for ips/subnets
{%-         for ip in service_details.get('ips_allow', ['0.0.0.0/0']) %}
{%-           if interfaces == '' %}
{%-             for proto in protos %}
iptables_{{ service_name }}_allow_{{ ip }}_{{ proto }}{{ suffixes[protocol] }}:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - source: {{ ip }}
    - dport: {{ service_name }}
    - proto: {{ proto }}
{%-               if protocol == ipv6 %}
    - family: ipv6
{%-               endif %}
    - save: True
    {{ comment }}
{%-             endfor %}
{%-           else %}
{%-             for interface in interfaces %}
{%-               for proto in protos %}
iptables_{{ service_name }}_allow_{{ ip }}_{{ proto }}_{{ interface }}{{ suffixes[protocol] }}:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - i: {{ interface }}
    - source: {{ ip }}
    - dport: {{ service_name }}
    - proto: {{ proto }}
{%-                 if protocol == ipv6 %}
    - family: ipv6
{%-                 endif %}
    - save: True
    {{ comment }}
{%-               endfor %}
{%-             endfor %}
{%-           endif %}
{%-         endfor %}

{%-         if not strict_mode and global_block_nomatch or block_nomatch %}
# If strict mode is disabled we may want to block anything else
{%-           if interfaces == '' %}
{%-             for proto in protos %}
iptables_{{ service_name }}_deny_other_{{ proto }}{{ suffixes[protocol] }}:
  iptables.append:
    - position: last
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - dport: {{ service_name }}
    - proto: {{ proto }}
{%-               if protocol == ipv6 %}
    - family: ipv6
{%-               endif %}
    - save: True
    {{ comment }}
{%-             endfor %}
{%-           else %}
{%-             for interface in interfaces %}
{%-               for proto in protos %}
iptables_{{ service_name }}_deny_other_{{ proto }}_{{ interface }}{{ suffixes[protocol] }}:
  iptables.append:
    - position: last
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - i: {{ interface }}
    - dport: {{ service_name }}
    - proto: {{ proto }}
{%-                 if protocol == ipv6 %}
    - family: ipv6
{%-                 endif %}
    - save: True
    {{ comment }}
{%-               endfor %}
{%-             endfor %}
{%-           endif %}
{%-         endif %}
{%-       endfor %}
{%-     endfor %}

# Generate rules for NAT
{%-     for service_name, service_details in firewall.get('nat', {}).items() %}
{%-       for ip_s, ip_ds in service_details.get('rules', {}).items() %}
{%-         for ip_d in ip_ds %}
iptables_{{ service_name }}_allow_{{ ip_s }}_{{ ip_d }}:
  iptables.append:
    - table: nat
    - chain: POSTROUTING
    - jump: MASQUERADE
    - o: {{ service_name }}
    - source: {{ ip_s }}
    - destination: {{ ip_d }}
    - save: True
{%-         endfor %}
{%-       endfor %}
{%-     endfor %}

# Generate rules for whitelisting IP classes
{%-     for protocol in protocols %}
{%-       for service_name, service_details in firewall.get('whitelist' + suffixes[protocol], {}).items() %}
{%-         for ip in service_details.get('ips_allow', []) %}
iptables_{{ service_name }}_allow_{{ ip }}{{ suffixes[protocol] }}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - source: {{ ip }}
  {%-         if protocol == ipv6 %}
    - family: ipv6
  {%-         endif %}
    - save: True
{%-         endfor %}
{%-       endfor %}
{%-     endfor %}
{%-   endif %}

{%- else %} # Firewall is disabled by default
firewall_disabled:
  test.show_notification:
    - name: Firewall is disabled by default
    - text: firewall:enabled is False
{%- endif %}
