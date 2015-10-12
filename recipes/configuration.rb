settings = Jira.settings(node)

if settings['database']['type'] == 'mysql'
  mysql_connector_j "#{node['jira']['install_path']}/lib"
end

directory node['jira']['home_path'] do
  owner node['jira']['user']
  action :create
  recursive true
end

template "#{node['jira']['home_path']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner node['jira']['user']
  mode '0644'
  variables :database => settings['database']
  notifies :restart, 'service[jira]', :delayed
end
