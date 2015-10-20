source 'https://supermarket.chef.io'

metadata

cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector'
cookbook 'file', github: 'jenssegers/chef-filehelper', protocol: :https

group :integration do
  cookbook 'apt'
  cookbook 'java'
  cookbook 'tomcat'
  cookbook 'minitest-handler'
end
