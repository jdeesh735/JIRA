template "#{node['jira']['install_path']}/atlassian-jira/WEB-INF/classes/crowd.properties" do
  source 'crowd.properties.erb'
  owner 'root'
  group 'root'
  mode 00644
  action :create
  variables(
    :sso_appname => node['jira']['crowd_sso']['sso_appname'],
    :sso_password => node['jira']['crowd_sso']['sso_password'],
    :crowd_base_url => node['jira']['crowd_sso']['crowd_base_url']
  )
  notifies :restart, 'service[jira]', :delayed
  only_if { node['jira']['crowd_sso']['enabled'] == true }
end

# Update config to activate Crowd's authenticator to enable SSO
# See: https://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+JIRA
file_replace_line "#{node['jira']['install_path']}/atlassian-jira/WEB-INF/classes/seraph-config.xml" do
  replace '    <authenticator class="com.atlassian.jira.security.login.JiraSeraphAuthenticator"/>'
  with    '    <authenticator class="com.atlassian.jira.security.login.SSOSeraphAuthenticator"/>'
  notifies :restart, "service[jira]", :delayed
  only_if { node['jira']['crowd_sso']['enabled'] == true }
end
