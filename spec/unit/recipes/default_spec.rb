#
# Cookbook Name:: nfs_server
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

RSpec.describe 'nfs_server::default' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }
  context 'When all attributes are default, on an unspecified platform' do
    let(:opts) { {} }
    include_examples 'converges successfully'
  end
  supported_platforms = {
    'centos' => %w(7.0 7.1.1503),
    'fedora' => %w(20 21)
  }

  supported_platforms.each do |platform, versions|
    versions.each do |version|
      let(:opts) { { platform: platform, version: version } }
      include_examples 'converges successfully'
      subject { chef_run }
      it { is_expected.to include_recipe 'nfs::server4' }
      it { is_expected.to include_recipe 'firewalld' }
      it { is_expected.to create_nfs_export '/srv' }
    end
  end
end
