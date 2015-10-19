require 'spec_helper'

describe 'jira::installer' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['jira']['version'] = '6.4.7'
      node.set['jira']['install_path'] = '/foo/jira'
      node.automatic['kernel']['machine'] = 'x86_64'
    end.converge(described_recipe)
  end

  context 'When JIRA is not installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:jira_version).and_return(nil)
    end

    it 'renders a response file for clean installation' do
      expect(chef_run).to render_file('/var/cache/chef/atlassian-jira-response.varfile')
        .with_content { |content|
          expect(content).to include('sys.confirmedUpdateInstallationString=false')
        }
    end

    it 'downloads the installer' do
      expect(chef_run).to create_remote_file('/var/cache/chef/atlassian-jira-6.4.7.bin')
        .with(
          source: 'http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.4.7-x64.bin',
          checksum: '95db7901de1f0c3d346b6ce716cbdf8cd7dc8333024c26b4620be78ba70f3212'
        )
    end

    it 'installs JIRA' do
      expect(chef_run).to run_execute('Installing Jira 6.4.7')
        .with(command: './atlassian-jira-6.4.7.bin -q -varfile atlassian-jira-response.varfile')
    end
  end

  context 'When other JIRA version is installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:jira_version).and_return('6.3.15')
    end

    it 'renders a response file for update' do
      allow(Dir).to receive(:exist?).with('/foo/jira').and_return(true)

      expect(chef_run).to render_file('/var/cache/chef/atlassian-jira-response.varfile')
        .with_content { |content|
          expect(content).to include('sys.confirmedUpdateInstallationString=true')
        }
    end

    it 'downloads the installer' do
      expect(chef_run).to create_remote_file('/var/cache/chef/atlassian-jira-6.4.7.bin')
        .with(
          source: 'http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-6.4.7-x64.bin',
          checksum: '95db7901de1f0c3d346b6ce716cbdf8cd7dc8333024c26b4620be78ba70f3212'
        )
    end

    it 'installs JIRA' do
      expect(chef_run).to run_execute('Installing Jira 6.4.7')
        .with(command: './atlassian-jira-6.4.7.bin -q -varfile atlassian-jira-response.varfile')
    end
  end

  context 'When the appropriate JIRA version is already installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:jira_version).and_return('6.4.7')
    end

    it 'does not run the installer' do
      expect(chef_run).not_to run_execute('Installing Jira 6.4.7')
    end
  end
end
