# This recipe tries to autotune various settings, most notable JVM heap size.
#
# The idea and portions of the code were taken from the hw-cookbooks/postgresql
# cookbook and its config_pgtune recipe.
#
# See https://github.com/hw-cookbooks/postgresql

# To add in future
# Dependent on DB?
# default['jira']['database']['pool-min-size'] = '30'
# default['jira']['database']['pool-max-size'] = '30'
# default['jira']['database']['pool-max-wait'] = '30000'
# default['jira']['database']['pool-max-idle'] = '30'

# MAYBE DO in future?
# -Datlassian.mail.senddisabled=true
# -Djava.security.egd=file:///dev/urandom

tune_type = 'mixed'

# Check if type is selected and if its a valid type
if (node['jira'].attribute?('autotune') && node['jira']['autotune'].attribute?('type'))
  tune_type = node['jira']['autotune']['type']

  if (!(['mixed','dedicated','shared'].include?(tune_type)))
    Chef::Log.fatal([
        "Bad value (#{tune_type}) for node['jira']['autotune']['type'] attribute.",
        "Valid values are one of mixed, dedicated, shared."
      ].join(' '))
    raise
  end
end

# Parse out total_memory option, or use value detected by Ohai.
total_memory = node['memory']['total']

if (node['jira'].attribute?('autotune') && node['jira']['autotune'].attribute?('total_memory'))
  total_memory = node['jira']['autotune']['total_memory']
  if (total_memory.match(/\A[1-9]\d*kB\Z/) == nil)
    Chef::Application.fatal!([
        "Bad value (#{total_memory}) for node['jira']['autotune']['total_memory'] attribute.",
        "Valid values are non-zero integers followed by m (e.g., 49416564kB)."
      ].join(' '))
  end
end

# Ohai reports node[:memory][:total] in kB, as in "921756kB"
mem = total_memory.split("kB")[0].to_i / 1024 # in MB

maximum_memory =
  { "mixed" => (mem / 100) * 70,
    "dedicated" => (mem / 100) * 80,
    "shared" => (mem / 100) * 50
  }.fetch(tune_type)

node.default['jira']['jvm']['maximum_memory'] = normalize(maximum_memory*1024*1024)
Chef::Log.warn("Autotuning JIRA max memory to #{node['jira']['jvm']['maximum_memory']}.")

minimum_memory =
  { "mixed" => (maximum_memory / 100) * 80,
    "dedicated" => maximum_memory,
    "shared" => (maximum_memory / 100) * 50
  }.fetch(tune_type)

node.default['jira']['jvm']['minimum_memory'] = normalize(minimum_memory*1024*1024)
Chef::Log.warn("Autotuning JIRA min memory to #{node['jira']['jvm']['minimum_memory']}.")

# Lets make sure we have at least 512 MB
if (minimum_memory < 512)
  Chef::Log.fatal("Autotune reports less than 512 MB available for JIRA, please make at least 512 MB memory available.")
  raise
end
