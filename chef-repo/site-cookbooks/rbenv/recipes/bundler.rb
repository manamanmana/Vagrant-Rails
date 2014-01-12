#
# Cookbook Name:: rbenv
# Recipe:: bundler
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "install-rbenv-bundler" do
  user node[:system][:user]
  group node[:system][:group]
  cwd node[:system][:home]
  environment "HOME" => node[:system][:home]
  code <<-EOH
  source #{node[:rbenv][:env_file]}; rbenv exec gem install bundler --no-rdoc --no-ri
  source #{node[:rbenv][:env_file]}; rbenv rehash
  EOH
end