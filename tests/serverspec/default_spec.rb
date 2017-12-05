require "spec_helper"
require "serverspec"

package = "iked"
service = "iked"
config  = "/etc/iked/iked.conf"
user    = "iked"
group   = "iked"
ports   = [PORTS]
log_dir = "/var/log/iked"
db_dir  = "/var/lib/iked"

case os[:family]
when "freebsd"
  config = "/usr/local/etc/iked.conf"
  db_dir = "/var/db/iked"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("iked") }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/iked") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
