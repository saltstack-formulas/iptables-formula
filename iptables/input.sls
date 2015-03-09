  # if no input section defined, try legacy pillar without input/output
  # sections and input services/whitelist are directly under firewall
  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set input = firewall.get( 'input' , firewall ) %}
  {% set strict_mode = input.get('strict', False ) %}
  {% set global_block_nomatch = input.get('block_nomatch', False) %}


  # Input Strict Mode
  # when Enabled, add rules for localhost/established connections 
  #   at the top and set policy to reject
  # when Disabled, remove rules for localhost/established connections
  #   and set policy to allow

  {% if strict_mode %}
    {% set action = 'insert' %}
    {% set policy = 'DROP' %}
    {% set strict_position = '- position: 1' %}
    {% set white_position  = '- position: 3' %}
  {%- else %}
    {% set action = 'delete' %}
    {% set policy = 'ACCEPT' %}
    {% set strict_position = '' %}
    {% set white_position = '- position: 1' %}
  {%- endif %}

      # Rule for related/established sessions
      iptables_INPUT_allow_established:
        iptables.{{ action }}:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - match: conntrack
          - ctstate: 'RELATED,ESTABLISHED'
          - save: True            
          {{ strict_position }}

      # Rule for localhost communications
      iptables_INPUT_allow_localhost:
        iptables.{{ action }}:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: 127.0.0.1
          - save: True
          {{ strict_position }}

  # Set the input policy to deny everything not explicitly allowed
      iptables_INPUT_enable_reject_policy:
        iptables.set_policy:
          - table: filter
          - chain: INPUT
          - policy: {{ policy }}
          - require:
            - iptables: iptables_INPUT_allow_localhost
            - iptables: iptables_INPUT_allow_established


  # Rules for inbound whitelist IP classes
  # put whitelist rules below strict rules and above service rules
  {%- for service_name, service_details in input.get('whitelist', {}).items() %}
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_INPUT_whitelist_allow_{{ip}}:
        iptables.insert:
           - table: filter
           - chain: INPUT
           - jump: ACCEPT
           - source: {{ ip }}
           - save: True
           {{ white_position }}
    {%- endfor %}

  # Remove whitelist IPs in ips_remove
  {%- for ip in service_details.get('ips_remove',{} ) %}
      iptables_INPUT_whitelist_allow_{{ip}}:
        iptables.delete:
           - table: filter
           - chain: INPUT
           - jump: ACCEPT
           - source: {{ ip }}
           - save: True
    {%- endfor%}
  {%- endfor %}


  # Rules for services
  {%- for service_name, service_details in input.get('services', {}).items() %}
    {% set block_nomatch = service_details.get('block_nomatch', False) %}

    # Check if rule is marked for removal
    {%- if service_details.get('remove') %}
      {% set action = 'delete' %}
    {%- else %}
      {% set action = 'append' %}
    {%- endif %}

    #Allow rules for ips/subnets
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_INPUT_{{service_name}}_allow_{{ip}}:
        iptables.{{ action }}:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ service_name }}
          - proto: tcp
          - save: True
    {%- endfor %}

    # Remove any IPs in ips_remove
    {%- for ip in service_details.get('ips_remove',{}) %}

      iptables_INPUT_{{service_name}}_allow_{{ip}}:
        iptables.delete:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ service_name }}
          - proto: tcp
          - save: True

    {%- endfor %}

    # no_match rules
    # Only add no_match rule when strict is false and a no_match is true and the service is not marked remove
    {%- if not strict_mode and ( global_block_nomatch or block_nomatch ) and not service_details.get('remove') %}
      {% set action = 'append' %}
    {%- else %}
      {% set action = 'delete' %}
    {%- endif %}

    # no_match blocking rule
      iptables_INPUT_{{service_name}}_deny_other:
        iptables.{{ action }}:
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ service_name }}
          - proto: tcp
          - save: True

  {%- endfor %}
