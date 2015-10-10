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

if node['init_package'] == 'systemd'
  execute 'systemctl-daemon-reload' do
    command '/bin/systemctl --system daemon-reload'
    action :nothing
  end

  template '/etc/systemd/system/jira.service' do
    source 'jira.systemd.erb'
    mode '0755'
    notifies :run, 'execute[systemctl-daemon-reload]', :immediately
    notifies :restart, 'service[jira]', :delayed
  end
else
  template '/etc/init.d/jira' do
    source 'jira.init.erb'
    mode '0755'
    notifies :restart, 'service[jira]', :delayed
  end
end

service 'jira' do
  supports :status => :true, :restart => :true
  action :enable
  subscribes :restart, 'java_ark[jdk]'
end

template "#{node['jira']['install_path']}/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source 'jira-application.properties.erb'
  owner node['jira']['user']
  mode '0644'
  notifies :restart, 'service[jira]', :delayed
end
