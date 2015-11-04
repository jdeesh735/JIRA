require 'spec_helper'

describe 'Postgresql' do
  describe port(5432) do
    it { should be_listening }
  end
end

describe 'JIRA' do
  it_behaves_like 'jira behind the apache proxy'
end
