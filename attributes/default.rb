default['nfs']['port']['statd']     = 32_765
default['nfs']['port']['statd_out'] = 32_766
default['nfs']['port']['mountd']    = 32_767
default['nfs']['port']['lockd']     = 32_768

default['ftp']['anonymous_enable'] = true
default['ftp']['banner'] = "Welcome to #{node['fqdn']} FTP Service!"
default['ftp']['use_localtime'] = true
