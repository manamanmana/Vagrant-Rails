#
# Cookbook Name:: system
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# For faster networking of centos on Virtualbox
bash "modify resolve.conf for faster networking" do
  code <<-EOS
  grep -q "options single-request-reopen" /etc/resolv.conf || \
    echo "options single-request-reopen" >> /etc/resolv.conf
  EOS

  action :run
end

# yum update -y
execute "yum update system" do
  command "yum update -y"
  timeout 25200

  action :run
end

# install Development tools group
bash "Install Development tools group" do
  code <<-EOS
  yum groupinstall "Development tools"
  EOS
end

# Install libraries
# libaio and libaio-devel is needed to install mysql56
%w(zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel libaio libaio-devel).each do |pkg|
  package pkg do
    action :install
  end
end

# Install git
package "git" do
  action :install
end

# Stop firewall
service "iptables" do
  action [:disable, :stop]
end