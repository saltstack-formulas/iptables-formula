  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set output = firewall.get( 'output' , {} ) %}
  {% set strict_mode = output.get('strict', False ) %}
  {% set global_block_nomatch = output.get('block_nomatch', False ) %}

  # Output Strict Mode
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
      iptables_OUTPUT_allow_established:
        iptables.{{ action }}:
          - table: filter
          - chain: OUTPUT
          - jump: ACCEPT
          - match: conntrack
          - ctstate: 'RELATED,ESTABLISHED'
          - save: True       
          {{ strict_position }}

   # Rule for localhost communications
      iptables_OUTPUT_allow_localhost:
        iptables.{{ action }}:
          - table: filter
          - chain: OUTPUT
          - jump: ACCEPT
          - destination: 127.0.0.1
          - save: True
          {{ strict_position }}

  # Set the output policy to deny everything not explicitly allowed
      iptables_OUTPUT_enable_reject_policy:
        iptables.set_policy:
          - table: filter
          - chain: OUTPUT
          - policy: {{ policy }}
          - require:
            - iptables: iptables_OUTPUT_allow_localhost
            - iptables: iptables_OUTPUT_allow_established


  # Rules for outbound whitelist IP classes
  # put whitelist rules below strict rules and above service rules
  {%- for service_name, service_details in output.get('whitelist', {}).items() %}
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_OUTPUT_whitelist_allow_{{ip}}:
        iptables.insert:
           - table: filter
           - chain: OUTPUT
           - jump: ACCEPT
           - destination: {{ ip }}
           - save: True
           {{ white_position }}
    {%- endfor %}

  # Remove whitelist for ips_remove
  {%- for ip in service_details.get('ips_remove',{}) %}
      iptables_OUTPUT_whitelist_allow_{{ip}}:
        iptables.delete:
           - table: filter
           - chain: OUTPUT
           - jump: ACCEPT
           - destination: {{ ip }}
           - save: True
    {%- endfor %}
  {%- endfor %}


  # Rules for services
  {%- for service_name, service_details in output.get('services', {}).items() %}
    {% set block_nomatch = service_details.get('block_nomatch', False) %}

    # Check if rule is marked for removal
    {%- if service_details.get('remove') %}
      {% set action = 'delete' %}
    {%- else %}
      {% set action = 'append' %}
    {%- endif %}

    #Allow rules for ips/subnets
    {%- for ip in service_details.get('ips_allow',{}) %}
      iptables_OUTPUT_{{service_name}}_allow_{{ip}}:
        iptables.{{ action }}:
          - table: filter
          - chain: OUTPUT
          - jump: ACCEPT
          - destination: {{ ip }}
          - dport: {{ service_name }}
          - proto: tcp
          - save: True
    {%- endfor %}

    #Remove any IPs in ips_remove
    {%- for ip in service_details.get('ips_remove',{}) %}
      iptables_OUTPUT_{{service_name}}_allow_{{ip}}:
        iptables.delete:
          - table: filter
          - chain: OUTPUT
          - jump: ACCEPT
          - destination: {{ ip }}
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
      iptables_OUTPUT_{{service_name}}_deny_other:
        iptables.{{ action }}:
          - table: filter
          - chain: OUTPUT
          - jump: REJECT
          - dport: {{ service_name }}
          - proto: tcp
          - save: True


  {%- endfor %}
