  {% set firewall = salt['pillar.get']('firewall', {}) %}

  # if flush = true, set policy to ACCEPT and flush all 
  {% set flush = firewall.get('flush', False ) %}
  {%- if flush %}
      iptables_INPUT_policy_accept:
        iptables.set_policy:
          - table: filter
          - chain: INPUT
          - policy: ACCEPT

      iptables_OUTPUT_policy_accept:
        iptables.set_policy:
          - table: filter
          - chain: OUTPUT
          - policy: ACCEPT

      iptables_flush:
        iptables.flush:
          - table: filter
          - require:
            - iptables: iptables_INPUT_flush_policy_accept
            - iptables: iptables_OUTPUT_flush_policy_accept
  {%- endif %}