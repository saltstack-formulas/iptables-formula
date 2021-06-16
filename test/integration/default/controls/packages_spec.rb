# frozen_string_literal: true

common_packages = ['iptables']

all_packages =
  case platform[:name]
  when 'debian', 'ubuntu'
    common_packages + %w[iptables-persistent netbase]
  else
    case system.platform[:finger]
    when 'fedora-34'
      ['iptables-compat']
    else
      common_packages
    end
  end

control 'Packages' do
  all_packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
