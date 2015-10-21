ark_prefix_path = ::File.dirname(node['jira']['install_path']) if ::File.basename(node['jira']['install_path']) == 'jira'
ark_prefix_path ||= node['jira']['install_path']

directory File.dirname(node['jira']['home_path']) do
  mode 00755
  action :create
  recursive true
end

user node['jira']['user'] do
  comment 'JIRA Service Account'
  home node['jira']['home_path']
  shell '/bin/bash'
  supports :manage_home => true
  system true
  action :create
end

directory ark_prefix_path do
  action :create
  recursive true
end

ark 'jira' do
  url jira_artifact_url
  prefix_root ark_prefix_path
  prefix_home ark_prefix_path
  checksum jira_artifact_checksum
  owner 'root'
  group 'root'
  version node['jira']['version']
  notifies :restart, 'service[jira]'
end

# See: https://confluence.atlassian.com/jira/installing-jira-from-an-archive-file-on-windows-linux-or-solaris-240910362.html
%w(logs temp work).each do |d|
  directory "#{node['jira']['install_path']}/#{d}" do
    owner node['jira']['user']
    group node['jira']['user']
    mode 00755
    action :create
  end
end
