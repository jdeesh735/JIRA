settings = Jira.settings(node)

include_recipe 'chef_jira::database' if settings['database']['host'] == '127.0.0.1'
include_recipe 'chef_jira::configuration'
include_recipe 'chef_jira::container_server_configuration'
include_recipe 'chef_jira::apache2'
include_recipe 'chef_jira::crowd_sso' if node['jira']['crowd_sso']['enabled'] == true
