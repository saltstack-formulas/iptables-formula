# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "iptables/map.jinja" import firewall with context %}

{%- for t in ['filter','nat','mangle'] %}
  {%- for cn, cv in firewall.get(t).items() %}
chain_present_{{ t }}_{{ cn }}:
  iptables.chain_present:
    - table: {{ t }}
    - name: {{ cn }}
  {%- endfor %}

  {%- for cn, cv in firewall.get(t).items() %}
    {%- set pol = cv.policy | default('ACCEPT') %}
    {%- set rules = cv.rules | default({}) %}
    {%- for r in rules %}
rule_{{ t }}_{{ cn }}_{{ r }}:
      {%- if rules[r]['position'] is defined %}
  iptables.insert:
      {%- else %}
  iptables.append:
      {%- endif %}
    - table: {{ t }}
    - chain: {{ cn }}
        {%- for k,v in rules[r].items() %}
    - {{ k }}: '{{ v }}'
        {%- endfor %}
    - save: true
    - require:
      - iptables: chain_present_{{ t }}_{{ cn }}
    {%- endfor %}

    {%- if cn in ['INPUT','OUTPUT','FORWARD','PREROUTING','POSTROUTING'] %}
    # Set policies
policy_{{ t }}_{{ cn }}_{{ pol }}:
  iptables.set_policy:
    - table: {{ t }}
    - chain: {{ cn }}
    - policy: {{ pol }}
    - save: true
    {%- endif %}
  {%- endfor %}
{%- endfor %}
