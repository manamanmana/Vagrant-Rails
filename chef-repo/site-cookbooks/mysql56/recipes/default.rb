#
# Cookbook Name:: mysql56
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## This is totally inspired from http://d.hatena.ne.jp/takemaru123/20140104/1388857028
## I used the part of install and setting up mysql56

# Get the packages from jaist.ac.jp
# node['mysql']['file_name'], node['mysql']['remote_uri'] is set as default attributes
# but you can set them as nodes json
# ref: http://nigohiroki.hatenablog.com/entry/2013/11/03/025405
remote_file "/tmp/#{node['mysql']['file_name']}" do
  source "#{node['mysql']['remote_uri']}"
  not_if { File.exists?("/tmp/#{node['mysql']['file_name']}") }
end

bash "install_mysql" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    tar xf "#{node['mysql']['file_name']}"
  EOH

  action :run
end

# delete to avoid conflicts
package "mysql-libs" do
  action :remove
end

# Install
node['mysql']['rpm'].each do |rpm|
  package rpm[:package_name] do
    action :install
    provider Chef::Provider::Package::Rpm
    source "/tmp/#{rpm[:rpm_file]}"
  end
end

# Start server
service "mysql" do
  action [:start, :enable]
end

# my.cnf
template "my.cnf" do
    path "/etc/my.cnf"
    source "my.cnf.erb"
    mode 0644
    action :create
    notifies :restart, 'service[mysql]'
end

# Initial password settings
# ref: http://blog.youyo.info/blog/2013/07/11/chef-mysql56/
script "Secure_Install" do
  interpreter 'bash'
  user "root"
  not_if "mysql -u root -p#{node[:mysql][:password]} -e 'show databases'"
  code <<-EOL
    export Initial_PW=`head -n 1 /root/.mysql_secret |awk '{print $(NF - 0)}'`
    mysql -u root -p${Initial_PW} --connect-expired-password -e "SET PASSWORD FOR root@localhost=PASSWORD('#{node[:mysql][:password]}');"
    mysql -u root -p#{node[:mysql][:password]} -e "SET PASSWORD FOR root@'127.0.0.1'=PASSWORD('#{node[:mysql][:password]}');"
    mysql -u root -p#{node[:mysql][:password]} -e "FLUSH PRIVILEGES;"
  EOL
end
