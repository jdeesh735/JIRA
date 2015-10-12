settings = Jira.settings(node)

include_recipe 'chef_jira::database' if settings['database']['host'] == 'localhost'
include_recipe "chef_jira::#{node['jira']['install_type']}"
include_recipe 'chef_jira::configuration'
include_recipe 'chef_jira::container_server_configuration'
include_recipe 'chef_jira::apache2'
