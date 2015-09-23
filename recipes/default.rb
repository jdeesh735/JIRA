settings = Jira.settings(node)

include_recipe 'chef_jira::database' if settings['database']['host'] == 'localhost'
include_recipe "chef_jira::#{node['jira']['install_type']}"
include_recipe 'chef_jira::configuration'
include_recipe 'chef_jira::build_war' if node['jira']['install_type'] == 'war'
include_recipe 'chef_jira::container_server_jars'
include_recipe 'chef_jira::container_server_configuration'
unless node['jira']['install_type'] == 'war'
  include_recipe "chef_jira::#{node['jira']['init_type']}"
  include_recipe 'chef_jira::apache2'
end
