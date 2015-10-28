#
# Cookbook Name:: nfs_server
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe 'firewalld'

yum_package 'nfs-utils' do
  action :install
end

service 'rpcbind' do
  action [:start, :enable]
end

service 'firewalld' do
  action [:stop, :disable]
end

include_recipe 'nfs::server4'

nfs_export '/srv' do
  network '*' # '192.168.0.0/16'
  writeable true
  sync true
  options %w(all_squash insecure)
end
