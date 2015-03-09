  {% set firewall = salt['pillar.get']('firewall', {}) %}
  {% set install = firewall.get('install', False) %}

  {% set packages = salt['grains.filter_by']({
    'Debian': ['iptables', 'iptables-persistent'],
    'RedHat': ['iptables'],
    'default': 'Debian'}) %}

  # Install required packages for firewalling      
  {%- if install %}
      iptables_packages:
        pkg.installed:
          - pkgs:
            {%- for pkg in packages %}
            - {{pkg}}
            {%- endfor %}
  {%- endif %}