Vagrant-Rails
=============
This is a Vagrant environment which creates __Ruby on Rails environment on CentOS 64 system__.
Please be care this Vagrantfile and Chef recipes are only focusing on making it work only on CentOS 64, so if you need to make it work on other platform like Ubuntu, you need to modify this or use other Vagrantfile and Chef recipes.

This Vagrant file creates environment below on CentOS 64.
* The latest yum update
* Development group yum install
* Install other compile and make tools, and libraries needed.
* git
* iptables off and disable (_please be care this is only for local development Vagrant environment, please don't do this on production environment_)
* MySQL56 (Client, Server, Devel, Shared)
* rbenv environment (_rbenv env is installed under the /home/vagrant, you can change this._)
* ruby-build environment under rbenv
* Ruby whose version is specified in Vagrantfile
* Bundler under the ruby environment


__Typical way to use this__

When you make new rails env and project.

* Clone this repo.

```
cd somewhere
git clone https://github.com/manamanmana/Vagrant-Rails.git
```

* Move Vagrantfile and chef-repo to project directory

```
mkdir project_name
mv somewhere/Vagrantfile project_name/
mv somewhere/chef-repo project_name/
```

* Launch Virtual box CentOS

```
vagrant box add centos64 /Users/manabu/Downloads/centos6_64.box
cd project_name

vim Vagrantfile
# Change box name and url as you need.
# Also you may need to change some network setting or add some settings.

vagrant up
vagrant provision
# This taks a bit long time...
```

* Login to Virtuan box CentOS

```
vagrant ssh

# In the CnetOS box
# Move to shared directory
cd /vagrant

mkdir app_name
cd app_name
bundle init
vim Gemfile
# Add rails gem to Gemfile
# Ex) gem "rails", "4.0.0"

# Install rails gem libraries in to app local
bundle install --path vendor/bundle

# make rails app structure here
bundle exec rails new . --slip-bundle
# Avoid to install required libs into system ruby
# You may be asked to overwrite Gemfile in the middle. Proceed with yes.

# Check the Gemfile again and uncomment some if you need.

# Install required library again into app local
bundle install --path vendor/bundle

# Launch rails server
bundle exec rails server

Enjoy!!
```

__Some notes__

> Recipe for MySQL56 is heavyly inspired from [this article](http://d.hatena.ne.jp/takemaru123/20140104/1388857028). Thanks a lots !!

> Some ruby version like 1.9.3 or 2.0.0 compling under rbenv/ruby-build environment may fail on centos.
> This comes from some bugs on the version of ruby core sources (especially ext/openssl/ossl_pkey_ec.c) .
> I prepared a patch for this from [here](https://gist.github.com/mpapis/8e9deda95da2d8e772d3/raw/8288ea2db82c808ae811198a9995bac4f8c34c0c/MRI-41808.patch), you can apply this automatically before compile the ruby version. Just turn "build_patch" => true in chef.json in Vagrantfile.
> So the better way is you try the provisioning with "build_patch" => false at first, and if you see the error, please turn it to true.

> This Vagrantfile uses vagrant-omnibus plugins.
> So please install it before you execute vagrant up
> vagrant plugin install vagrant-omnibus


