# Firewall management module
{%- if salt['pillar.get']('firewall:enabled') %}

      include:
        - .install
        - .flush
        - .input 
        - .output 
        - .nat

{%- endif %}


    # Here for debugging
      print_iptables:
        cmd.run:
          - name: "iptables -L"

