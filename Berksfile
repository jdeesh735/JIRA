source 'https://supermarket.getchef.com'

metadata

cookbook 'mysql_connector', git: 'https://github.com/bflad/chef-mysql_connector'

group :integration do
  cookbook 'java'
  cookbook 'tomcat'
  cookbook 'minitest-handler'
  cookbook 'jira_test', :path => 'test/cookbooks/jira_test'
end
