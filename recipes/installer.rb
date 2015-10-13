template "#{Chef::Config[:file_cache_path]}/atlassian-jira-response.varfile" do
  source 'response.varfile.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file "#{Chef::Config[:file_cache_path]}/atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin" do
  source jira_artifact_url
  checksum jira_artifact_checksum
  mode '0755'
  action :create_if_missing
  notifies :run, "execute[Installing Jira #{node['jira']['version']}]", :immediately
end

execute "Installing Jira #{node['jira']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command "./atlassian-jira-#{node['jira']['version']}-#{node['jira']['arch']}.bin -q -varfile atlassian-jira-response.varfile"
  not_if { node['jira']['update'] == false && ::File.directory?("#{node['jira']['install_path']}") }
end
