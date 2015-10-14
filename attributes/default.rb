default['jira']['home_path']          = '/var/atlassian/application-data/jira'
default['jira']['init_type']          = node['init_package'] # init (sysv) or systemd
default['jira']['install_path']       = '/opt/atlassian/jira'
default['jira']['install_type']       = 'installer'
default['jira']['version']            = '6.4.11'
default['jira']['user']               = 'jira'
default['jira']['backup_when_update'] = false
default['jira']['ssl']                = false
default['jira']['update']             = false

# Defaults are automatically selected from version via helper functions
default['jira']['url']      = nil
default['jira']['checksum'] = nil

default['jira']['apache2']['access_log']         = node['apache']['log_dir'] + '/jira-access.log'
default['jira']['apache2']['error_log']          = node['apache']['log_dir'] + '/jira-error.log'
default['jira']['apache2']['port']               = 80
default['jira']['apache2']['virtual_host_name']  = node['fqdn']
default['jira']['apache2']['virtual_host_alias'] = node['hostname']

default['jira']['apache2']['ssl']['access_log']       = node['apache']['log_dir'] + '/jira-ssl-access.log'
default['jira']['apache2']['ssl']['chain_file']       = ''
default['jira']['apache2']['ssl']['error_log']        = node['apache']['log_dir'] + '/jira-ssl-error.log'
default['jira']['apache2']['ssl']['port']             = 443

case node['platform_family']
when 'rhel'
  default['jira']['apache2']['ssl']['certificate_file'] = '/etc/pki/tls/certs/localhost.crt'
  default['jira']['apache2']['ssl']['key_file']         = '/etc/pki/tls/private/localhost.key'
else
  default['jira']['apache2']['ssl']['certificate_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
  default['jira']['apache2']['ssl']['key_file']         = '/etc/ssl/private/ssl-cert-snakeoil.key'
end

default['jira']['database']['host']     = 'localhost'
default['jira']['database']['name']     = 'jira'
default['jira']['database']['password'] = 'changeit'
default['jira']['database']['type']     = 'mysql'
default['jira']['database']['user']     = 'jira'

# Default is automatically selected from database type via helper function
default['jira']['database']['port'] = nil

default['jira']['jvm']['minimum_memory']  = '256m'
default['jira']['jvm']['maximum_memory']  = '768m'
default['jira']['jvm']['maximum_permgen'] = '256m'
default['jira']['jvm']['java_opts']       = ''
default['jira']['jvm']['support_args']    = ''

default['jira']['tomcat']['keyAlias']     = 'tomcat'
default['jira']['tomcat']['keystoreFile'] = "#{node['jira']['home_path']}/.keystore"
default['jira']['tomcat']['keystorePass'] = 'changeit'
default['jira']['tomcat']['port']     = '8080'
default['jira']['tomcat']['ssl_port'] = '8443'

default['jira']['crowd_sso']['enabled']        = false
default['jira']['crowd_sso']['sso_appname']    = 'jira'
default['jira']['crowd_sso']['sso_password']   = 'changethistosomethingsensible'
default['jira']['crowd_sso']['crowd_base_url'] = 'http://localhost:8095/crowd/'
