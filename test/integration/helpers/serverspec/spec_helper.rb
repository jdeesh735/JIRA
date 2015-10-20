require 'serverspec'

set :backend, :exec

shared_examples_for 'jira behind the apache proxy' do
  describe 'Tomcat' do
    describe port(8080) do
      it { should be_listening }
    end

    describe command("curl --noproxy localhost 'http://localhost:8080/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA Setup'") do
      its(:exit_status) { should eq 0 }
    end
  end

  describe 'Apache2' do
    describe port(80) do
      it { should be_listening }
    end

    describe port(443) do
      it { should be_listening }
    end

    describe command("curl --location --insecure --noproxy localhost 'http://localhost/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA Setup'") do
      its(:exit_status) { should eq 0 }
    end

    describe command("curl --insecure --noproxy localhost 'https://localhost/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA Setup'") do
      its(:exit_status) { should eq 0 }
    end
  end
end
