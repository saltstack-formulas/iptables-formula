#!stateconf yaml . jinja

.sls_params:
  stateconf.set:
    - parent: default

# --- end of state config ---

{%- if salt['pillar.get']("%s:firewall"|format(sls_params.parent)) %}
{% set pfirewall = salt['pillar.get']("%s:firewall"|format(sls_params.parent)) %}
# Firewall management module
{%- if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set install = firewall.get('install', False) %}
  {% set strict_mode = firewall.get('strict', False) %}
  {% set global_block_nomatch = firewall.get('block_nomatch', False) %}

  # Generate ipsets for all services that we have information about
  {%- for service_name, service_details in pfirewall.get('services', {}).items() %}  
    {% set block_nomatch = service_details.get('block_nomatch', False) %}

    # Allow rules for ips/subnets
    {%- for ip in service_details.get('ips_allow',{}) %}
.iptables_{{sls_params.parent}}_{{service_name}}_allow_{{ip}}:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - source: {{ ip }}
    - dport: {{ service_name }}
    - proto: tcp
    - save: True
    {%- endfor %}

    {%- if not strict_mode and global_block_nomatch or block_nomatch %}
# If strict mode is disabled we may want to block anything else
.iptables_{{sls_params.parent}}_{{service_name}}_deny_other:
  iptables.append:
    - position: last
    - table: filter
    - chain: INPUT
    - jump: REJECT
    - dport: {{ service_name }}
    - proto: tcp
    - save: True
    {%- endif %}    

  {%- endfor %}
{%- endif %}
{%- endif %}
