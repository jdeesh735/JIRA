require 'spec_helper'

describe 'chef_jira::installer' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
