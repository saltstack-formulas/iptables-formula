# In this example we iterate over tables (filter, nat, mangle) and
# adds the desired entries 
firewall:
  install: True
  enabled: True
  strict: True

  # To use tables, leave services undefined and set this to true
  use_tables: True

  whitelist:
    networks:
      ips_allow:
        - 10.10.10.0/24

  filter:
    INPUT:
      rules:
        test_ssh_rule:
          protocol: tcp
          dport: 22
          jump: ACCEPT
        test_rule:
          source: 172.22.172.0/24
          protocol: tcp
          match: multiport
          dports: 80,443
          jump: ACCEPT
    CUSTOM_CHAIN:
      rules:
        some_custom_rule:
          source: 192.168.12.0/23
          protocol: tcp
          dport: 2222
          jump: REJECT

  #Suppport nat
  # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 10.20.0.2 -j MASQUERADE
  # iptables -t nat -A POSTROUTING -o eth0 -s 192.168.18.0/24 -d 172.31.0.2 -j MASQUERADE
  nat:
    POSTROUTING:
      rules:
        masquerade:
          source: '192.168.18.0/24'
          destination: '10.20.0.2'
          jump: MASQUERADE
