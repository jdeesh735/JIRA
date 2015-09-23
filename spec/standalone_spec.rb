require 'spec_helper'

describe 'chef_jira::standalone' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
