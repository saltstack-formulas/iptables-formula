# frozen_string_literal: true

# rubocop:disable Layout/LineLength
control 'Rules' do
  describe iptables do
    it { should have_rule('-A INPUT -s 127.0.0.1/32 -j ACCEPT') }
    it {
      should have_rule('-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT')
    }

    it {
      should have_rule('-A INPUT -s 172.22.172.0/24 -p tcp -m multiport --dports 80,443 -j ACCEPT')
    }
    it {
      should have_rule('-A CUSTOM_CHAIN -s 192.168.12.0/23 -p tcp -m tcp --dport 2222 -j REJECT --reject-with icmp-port-unreachable')
    }
  end
  describe iptables(table: 'nat') do
    it {
      should have_rule('-A POSTROUTING -s 192.168.18.0/24 -d 10.20.0.2/32 -j MASQUERADE')
    }
  end
end
# rubocop:enable Layout/LineLength
