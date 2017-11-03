require 'serverspec'
set :backend, :exec

describe 'iptables packages' do
  it "iptables is installed" do
    expect(package("iptables")).to be_installed
  end

  if ['debian', 'ubuntu'].include?(os[:family])
    it "iptables-persistent is installed" do
      expect(package("iptables-persistent")).to be_installed
    end
  end
end

describe iptables do
  it { should have_rule('-A INPUT -s 127.0.0.1/32 -j ACCEPT') }
  it { should have_rule('-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT') }
  it { should have_rule('-A INPUT -s 192.168.0.0/24 -p tcp -m tcp --dport 22 -j ACCEPT') }
  it { should have_rule('-A INPUT -s 10.0.2.2/32 -p tcp -m tcp --dport 22 -j ACCEPT') }
  it { should have_rule('-A INPUT -s 10.0.0.0/8 -j ACCEPT') }
end
