#
# Cookbook Name:: rbenv
# Recipe:: ruby
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Make plugins directory in rbenv
directory "#{node[:rbenv][:install_path]}/plugins" do
  owner node[:system][:user]
  group node[:system][:group]
  action :create
end

# Clone ruby-built into rbenv plugins
git node[:rbenv][:ruby_built_install_path] do
  user node[:system][:user]
  group node[:system][:group]
  reference "master"
  repository node[:rbenv][:ruby_built_repo_url]
  action :checkout
end

configure_opion = ''

# This section is created because ruby-build fails on ruby-1.9.3 and ruby2.0.0 etc on centos
# So copy the patch and configure files into /tmp and use them as configure option when rbenv install
if node[:rbenv][:build_patch] then
  cookbook_file "/tmp/centos-configure" do
    mode 00755
  end

  cookbook_file "/tmp/build-patch.diff" do
    mode 00644
  end

  configure_opion = 'RUBY_CONFIGURE=/tmp/centos-configure '
end

# Install specified ruby
bash "install-rbenv-ruby" do
  not_if %Q|test -d #{node[:rbenv][:install_path]}/versions/#{node[:rbenv][:ruby_version]}|
  user node[:system][:user]
  group node[:system][:group]
  cwd node[:system][:home]
  environment "HOME" => node[:system][:home]
  code <<-EOH
  source #{node[:rbenv][:env_file]}; #{configure_opion} rbenv install -v #{node[:rbenv][:ruby_version]}
  source #{node[:rbenv][:env_file]}; rbenv rehash
  source #{node[:rbenv][:env_file]}; rbenv global #{node[:rbenv][:ruby_version]}
  EOH
  action :run
end