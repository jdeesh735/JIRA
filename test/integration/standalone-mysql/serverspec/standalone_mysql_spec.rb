require 'spec_helper'

describe 'MySQL' do
  describe port(3306) do
    it { should be_listening }
  end
end

describe 'JIRA' do
  it_behaves_like 'jira behind the apache proxy'
end
