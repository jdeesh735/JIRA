if jira_version != node['jira']['version']
  template "#{Chef::Config[:file_cache_path]}/atlassian-jira-response.varfile" do
    source 'response.varfile.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      'update' => Dir.exist?(node['jira']['install_path'])
    )
  end

  remote_file "#{Chef::Config[:file_cache_path]}/atlassian-jira-#{node['jira']['version']}.bin" do
    source jira_artifact_url
    checksum jira_artifact_checksum
    mode '0755'
    action :create
  end

  execute "Installing Jira #{node['jira']['version']}" do
    cwd Chef::Config[:file_cache_path]
    command "./atlassian-jira-#{node['jira']['version']}.bin -q -varfile atlassian-jira-response.varfile"
  end
else
  log "JIRA version #{node['jira']['version']} requested, but already at #{jira_version}. Nothing to do." do
    level :info
  end
end
