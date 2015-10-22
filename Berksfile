source 'https://supermarket.chef.io'

metadata

cookbook 'mysql_connector', github: 'bflad/chef-mysql_connector'

group :integration do
  cookbook 'apt'
  cookbook 'java'
  cookbook 'tomcat'
  cookbook 'minitest-handler'
end
