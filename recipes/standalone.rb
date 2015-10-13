ark_prefix_path = ::File.dirname(node['jira']['install_path']) if ::File.basename(node['jira']['install_path']) == 'jira'
ark_prefix_path ||= node['jira']['install_path']

directory File.dirname(node['jira']['home_path']) do
  owner 'root'
  group 'root'
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
  version node['jira']['version']
  owner node['jira']['user']
  group node['jira']['user']
  notifies :restart, 'service[jira]'
end
