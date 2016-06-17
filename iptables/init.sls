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
  iptables.insert:
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

  # Generate ipsets for all services that we have information about
  {%- for chain in ('INPUT', 'FORWARD', 'OUTPUT') %}
    {%- for service_name, service_details in firewall.get(chain.lower(), {}).items() %}
      {% set block_nomatch = service_details.get('block_nomatch', False) %}
      {% set command = service_details.get('command', 'append') %}
      {% set position = service_details.get('position', None if command == 'delete' else '1') %}
      {% set interfaces = service_details.get('interfaces', ['*']) %}
      {% set protos = service_details.get('protos', ['tcp']) %}

      # Allow rules for IPs/subnets
      {%- for ip in service_details.get('networks', ['*']) %}
        {%- for interface in interfaces %}
          {%- for proto in protos %}
iptables_{{service_name}}_allow_{{ip}}_{{proto}}{{ '_{}'.format(interface) if interface else '' }}:
  iptables.{{ command }}:
    {%- if command in ('insert', 'replace', 'delete') and position %}
    - position: {{ position }}
    {%- endif %}
    - table: filter
    - chain: {{ chain }}
    - jump: ACCEPT
    - dport: {{ service_name }}
    {%- if chain == 'INPUT' %}
      {%- if interface != '*' %}
    - i: {{ interface }}
      {%- endif %}
      {%- if ip != '*' %}
    - source: {{ ip }}
      {%- endif %}
    {%- elif chain == 'OUTPUT' %}
      {%- if interface != '*' %}
    - o: {{ interface }}
      {%- endif %}
      {%- if ip != '*' %}
    - destination: {{ ip }}
      {%- endif %}
    {%- else %}
      {%- if interface.split(':')[0].replace('*', '') %}
    - i: {{ interface.split(':')[0] }}
      {%- endif %}
      {%- if interface.split(':')[::-1][0].replace('*', '') %}
    - o: {{ interface.split(':')[::-1][0] }}
      {%- endif %}
    - source: {{ ip.split(':')[0].replace('*', '0.0.0.0/0') }}
    - destination: {{ ip.split(':')[::-1][0].replace('*', '0.0.0.0/0') }}
    {%- endif %}
    - proto: {{ proto }}
    - save: True
          {%- endfor %}
        {%- endfor %}
      {%- endfor %}

      {%- if not strict_mode and global_block_nomatch or block_nomatch and chain != 'FORWARD' %}
        # If strict mode is disabled we may want to block anything else
        {%- if interfaces == '' %}
          {%- for proto in protos %}
iptables_{{iface_name}}_deny_other_{{proto}}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: REJECT
    - dport: {{ iface_name }}
    - proto: {{ proto }}
    - save: True
          {%- endfor %}
        {%- else %}
          {%- for interface in interfaces %}
            {%- for proto in protos %}
iptables_{{iface_name}}_deny_other_{{proto}}_{{interface}}:
  iptables.append:
    - table: filter
    - chain: {{ chain }}
    - jump: REJECT
    - i: {{ interface }}
    - dport: {{ iface_name }}
    - proto: {{ proto }}
    - save: True
            {%- endfor %}
          {%- endfor %}
        {%- endif %}

      {%- endif %}

    {%- endfor %}
  {%- endfor %}

  # Generate rules for MASQUERADE
  {%- for iface_name, iface_details in firewall.get('masquerade', {}).items() %}
    {%- for ip_s, ip_ds in iface_details.items() %}
      {%- for ip_d in ip_ds %}
iptables_{{iface_name}}_allow_{{ip_s}}_{{ip_d}}:
  iptables.append:
    - table: nat
    - chain: POSTROUTING
    - jump: MASQUERADE
    - o: {{ iface_name }}
    - source: {{ ip_s }}
    - destination: {{ip_d}}
    - save: True
      {%- endfor %}
    {%- endfor %}
  {%- endfor %}

  # Generate rules for DNAT
  {%- for iface_name, iface_details in firewall.get('dnat', {}).items() %}
    {%- for service_name, service_details in iface_details.items() %}
iptables_{{ iface_name }}_dnat_{{ service_name }}:
  iptables.{{ service_details.get('command', 'append') }}:
    - table: nat
    - chain: PREROUTING
    - match: {{ service_details.get('proto', 'tcp') }}
    - protocol: {{ service_details.get('proto', 'tcp') }}
    - dport: {{ service_name }}
    {%- if iface_name.lower() != 'all' %}
    - i: {{ iface_name }}
    {%- endif %}
    - jump: DNAT
    - to-destination: {{ service_details['destination'] }}
    - save: True
    {%- endfor %}
  {%- endfor %}

  # Generate rules for whitelisting IP classes
  {%- for service_name, service_details in firewall.get('whitelist', {}).items() %}
    {%- for ip in service_details.get('ips_allow', []) %}
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
