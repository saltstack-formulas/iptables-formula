# frozen_string_literal: true

common_packages = ['iptables']

case os[:name]
when 'debian', 'ubuntu'
  all_packages = common_packages + %w[iptables-persistent netbase]
else
  all_packages = common_packages
end

control 'Packages' do
  all_packages.each do |p|
    describe package(p) do
      it { should be_installed }
    end
  end
end
