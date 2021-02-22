# frozen_string_literal: true

control 'Rules' do
  describe iptables do
    it { should have_rule('-A INPUT -s 127.0.0.1/32 -j ACCEPT') }
    it {
      should have_rule('-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT')
    }
    it {
      should have_rule('-A INPUT -s 192.168.0.0/16 -p tcp -m tcp --dport 22 -j ACCEPT')
    }
    it {
      should have_rule('-A INPUT -s 172.16.0.0/12 -p tcp -m tcp --dport 22 -j ACCEPT')
    }
    it { should have_rule('-A INPUT -s 10.0.0.0/8 -j ACCEPT') }
  end
end
