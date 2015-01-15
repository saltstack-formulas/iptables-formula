# Firewall management module
{%- if salt['pillar.get']('firewall:enabled') %}
  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set install = firewall.get('install', False) %}
  {% set strict_mode = firewall.get('strict', False) %}
  {% set global_block_nomatch = firewall.get('block_nomatch', False) %}
  {% set packages = salt['grains.filter_by']({
    'Debian': ['iptables', 'iptables-persistent'],
    'RedHat': ['iptables'],
    'default': 'Debian'}) %}

      {%- if install %}
      # Install required packages for firewalling
      iptables_packages:
        pkg.installed:
          - pkgs:
            {%- for pkg in packages %}
            - {{pkg}}
            {%- endfor %}
      {%- endif %}

    {%- if strict_mode %}
      # If the firewall is set to strict mode, we'll need to allow some
      # that always need access to anything
      iptables_allow_localhost:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: 127.0.0.1
          - save: True

      # Allow related/established sessions
      iptables_allow_established:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - match: conntrack
          - ctstate: 'RELATED,ESTABLISHED'
          - save: True

      # Set the policy to deny everything unless defined
      enable_reject_policy:
        iptables.set_policy:
          - table: filter
          - chain: INPUT
          - policy: DROP
          - require:
            - iptables: iptables_allow_localhost
            - iptables: iptables_allow_established
    {%- endif %}

  # Generate rules for redirect
  # Do these first because the filter rule needs to come first
  {%- for service_name, service_details in firewall.get('redirect', {}).items() %}
    {%- set from  = service_details.get('from_port','') %}
    {%- set to    = service_details.get('to_port','') %}
    {%- set proto = service_details.get('proto','tcp') %}
    {%- set mark  = service_details.get('mark','0x64') %}

    {%- for ip in service_details.get('ips_allow',{'0/0':[]}) %}
      # Allow rules for ips/subnets
      iptables_{{service_name}}_allow_{{ip}}_mark:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ to }}
          - proto: {{ proto }}
          - match:
            - state
            - mark
          - connstate: NEW
          - mark: '{{ mark }}'
          - save: True
  
      iptables_{{service_name}}_mangle_{{proto}}_{{from}}_{{to}}:
        iptables.append:
          - table: mangle
          - chain: PREROUTING
          - jump: MARK
          - source: {{ ip }}
          - proto: {{ proto }}
          - dport: {{ from }}
          - set-xmark: '{{ mark }}/0xffffffff'
          - save: True
  
      iptables_{{service_name}}_nat_{{proto}}_{{from}}_{{to}}:
        iptables.append:
          - table: nat
          - chain: PREROUTING
          - jump: DNAT
          - source: {{ ip }}
          - proto: {{ proto }}
          - dport: {{ from }}
          - match: mark
          - mark: '{{ mark }}'
          - to-destination: ':{{ to }}'
          - save: True
    {%- endfor %}
  {%- endfor %}

  # Generate ipsets for all services that we have information about
  {%- for service_name, service_details in firewall.get('services', {}).items() %}
    {% set block_nomatch = service_details.get('block_nomatch', False) %}
    {% set proto = service_details.get('proto', 'tcp') %}

    # Allow rules for ips/subnets
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_{{service_name}}_allow_{{ip}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ service_name }}
          - proto: {{ proto }}
          - save: True
    {%- endfor %}


    {%- if not strict_mode and global_block_nomatch or block_nomatch %}
      # If strict mode is disabled we may want to block anything else
      iptables_{{service_name}}_deny_other:
        iptables.append:
          - position: last
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ service_name }}
          - proto: {{ proto }}
          - save: True
    {%- endif %}

  {%- endfor %}

  # Generate rules for NAT
  {%- for service_name, service_details in firewall.get('nat', {}).items() %}
    {%- for ip_s, ip_d in service_details.get('rules', {}).items() %}
      iptables_{{service_name}}_allow_{{ip_s}}_{{ip_d}}:
        iptables.append:
          - table: nat
          - chain: POSTROUTING
          - jump: MASQUERADE
          - o: {{ service_name }}
          - source: {{ ip_s }}
          - destination: {{ip_d}}
          - save: True
    {%- endfor %}
  {%- endfor %}

  # Generate rules for whitelisting IP classes
  {%- for service_name, service_details in firewall.get('whitelist', {}).items() %}
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_{{service_name}}_allow_{{ip}}:
        iptables.append:
           - table: filter
           - chain: INPUT
           - jump: ACCEPT
           - source: {{ ip }}
           - save: True
    {%- endfor %}
  {%- endfor %}

{%- endif %}
