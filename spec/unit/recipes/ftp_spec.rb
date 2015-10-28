#
# Cookbook Name:: nfs_server
# Spec:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 J. Morgan Lieberthal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

RSpec.describe 'nfs_server::ftp' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  %w(7.0 7.1.1503).each do |version|
    context "on centos v#{version}" do
      let(:opts) { { platform: 'centos', version: version } }
      include_examples 'converges successfully'

      it 'installs vsftpd' do
        expect(chef_run).to install_yum_package('vsftpd')
      end

      it 'installs ftp' do
        expect(chef_run).to install_yum_package('ftp')
      end

      it 'creates the vsftpd.conf template' do
        expect(chef_run).to create_template('/etc/vsftpd/vsftpd.conf').with(
          source: 'vsftpd.conf.erb',
          mode: '0600',
          owner: 'root',
          group: chef_run.node['root_group']
        )
      end

      it 'starts the vsftpd service' do
        expect(chef_run).to start_service('vsftpd')
      end

      it 'enables the vsftpd service' do
        expect(chef_run).to enable_service('vsftpd')
      end

      it 'adds a firewall rule for port 21/tcp' do
        expect(chef_run).to add_firewalld_port('21/tcp')
      end

      it 'adds a firewall rule for ftp' do
        expect(chef_run).to add_firewalld_service('ftp')
      end

      it 'executes the selinux command' do
        expect(chef_run).to run_bash('setsebool')
      end
    end
  end
end
