require 'spec_helper'

RSpec.describe 'nfs_server::default' do
  describe package('firewalld') do
    it { is_expected.to be_installed }
  end

  describe service('firewalld') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  shared_examples 'firewall rules' do |rule, type, permanent|
    cmd = ['firewall-cmd']
    cmd << '--permanent' if permanent
    query = type == 'port' ? "--query-port=#{rule}" : "--query-service=#{rule}"
    cmd << query
    describe command("#{cmd.join(' ')}") do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  describe 'default firewall rules' do
    %w(ssh nfs).each do |svc|
      include_examples 'firewall rules', svc, 'service', true
      include_examples 'firewall rules', svc, 'service', false
    end
    %w(111/tcp 111/udp 20048/udp 20048/tcp).each do |port|
      include_examples 'firewall rules', port, 'port', true
      include_examples 'firewall rules', port, 'port', false
    end
  end

  describe 'nfs service and exports' do
    describe service('nfs-server') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe file('/etc/exports') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match %r{/srv} }
    end

    describe command('showmount -e') do
      its(:exit_status) { is_expected.to be 0 }
      its(:stdout) { is_expected.to match %r{/srv} }
    end
  end
end
