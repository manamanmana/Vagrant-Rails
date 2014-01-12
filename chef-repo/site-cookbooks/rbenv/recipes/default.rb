#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Clone rbenv
git node[:rbenv][:install_path] do
  user  "vagrant"
  group "vagrant"
  reference "master"
  repository  node[:rbenv][:repo_uri]
  action :checkout
end

# Coordinate environment
bash "init-rbenv-environment" do
  not_if %Q|grep -q "rbenv" #{node[:rbenv][:env_file]}|
  user node[:system][:user]
  group node[:system][:group]
  code <<-EOH
  echo 'export PATH="#{node[:rbenv][:install_path]}/bin:$PATH"' >> #{node[:rbenv][:env_file]}
  echo 'eval "$(rbenv init -)"' >> #{node[:rbenv][:env_file]}
  source #{node[:system][:home]}/.bash_profile
  EOH
  action :run
end