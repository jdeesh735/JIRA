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
end

# Update config to activate Crowd's authenticator to enable SSO
# See: https://confluence.atlassian.com/display/CROWD/Integrating+Crowd+with+Atlassian+JIRA
ruby_block "Set Crowd authenticator" do
  block do
    fe = Chef::Util::FileEdit.new("#{node['jira']['install_path']}/atlassian-jira/WEB-INF/classes/seraph-config.xml")
    sso_auth = '<authenticator class="com.atlassian.jira.security.login.SSOSeraphAuthenticator"/>'
    base_auth = '<authenticator class="com.atlassian.jira.security.login.JiraSeraphAuthenticator"/>'
    fe.search_file_replace(/#{Regexp.quote(base_auth)}/, sso_auth)
    fe.write_file
  end
  only_if %Q(grep '<authenticator class="com.atlassian.jira.security.login.JiraSeraphAuthenticator"/>' \
    #{node['jira']['install_path']}/atlassian-jira/WEB-INF/classes/seraph-config.xml)
  notifies :restart, 'service[jira]', :delayed
end
