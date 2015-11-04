require 'spec_helper'

describe 'jira::installer' do
  # version  = '6.4.7'
  # checksum = '95db7901de1f0c3d346b6ce716cbdf8cd7dc8333024c26b4620be78ba70f3212'
  version = '7.0.0'
  checksum = '49e12b2ba9f1eaa4ed18e0a00277ea7be19ffd6c55d4a692da3e848310815421'

  if Gem::Version.new(version) < Gem::Version.new(7)
    source = "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-#{version}-x64.bin"
  else
    source = "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-#{version}-jira-#{version}-x64.bin"
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['jira']['version'] = version
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
      expect(chef_run).to create_remote_file("/var/cache/chef/atlassian-jira-#{version}.bin")
        .with(
          source: "#{source}",
          checksum: "#{checksum}"
        )
    end

    it 'installs JIRA' do
      expect(chef_run).to run_execute("Installing Jira #{version}")
        .with(command: "./atlassian-jira-#{version}.bin -q -varfile atlassian-jira-response.varfile")
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
      expect(chef_run).to create_remote_file("/var/cache/chef/atlassian-jira-#{version}.bin")
        .with(
          source: "#{source}",
          checksum: "#{checksum}"
        )
    end

    it 'installs JIRA' do
      expect(chef_run).to run_execute("Installing Jira #{version}")
        .with(command: "./atlassian-jira-#{version}.bin -q -varfile atlassian-jira-response.varfile")
    end
  end

  context 'When the appropriate JIRA version is already installed' do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:jira_version).and_return(version)
    end

    it 'does not run the installer' do
      expect(chef_run).not_to run_execute("Installing Jira #{version}")
    end
  end
end
