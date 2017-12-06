require "spec_helper"
require "serverspec"

_package = "iked"
service = "iked"
config  = "/etc/iked.conf"
_user    = "_iked"
_group   = "_iked"
ports = [4500, 500]
from = Regexp.escape("0.0.0.0/0")
to = Regexp.escape("172.16.2.0/24")
peer = Regexp.escape("10.0.0.0/8")
local = Regexp.escape("192.168.56.0/24")
config_address = Regexp.escape("172.16.2.1")
tag = Regexp.escape("$name-$id")

describe file(config) do
  it { should be_file }
  its(:content) { should match(/^ikev2 "win7" esp \\\n\s+from #{from} to #{to} \\\n\s+peer #{peer} local #{local} \\\n\s+eap "mschap-v2" \\\n\s+config address #{config_address} \\\n\s+tag "#{tag}"$/) }
end

describe command("rcctl get iked flags") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should eq "-v\n" }
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening.with("udp") }
  end
end
