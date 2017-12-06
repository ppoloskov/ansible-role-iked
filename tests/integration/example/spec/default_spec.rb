require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  [server(:server1), server(:server2)].each do |s|
    describe s do
      let(:intranet_regexp) { Regexp.escape("172.16.2.0/24") }
      let(:all_regexp) { Regexp.escape("0.0.0.0/0") }
      let(:peer) { current_server.address == "192.168.21.201" ? "192.168.21.202" : "192.168.21.201" }
      let(:local) { current_server.address == "192.168.21.201" ? "192.168.21.201" : "192.168.21.202" }
      let(:local_regexp) { Regexp.escape(local) }
      let(:peer_regexp) { Regexp.escape(peer) }
      let(:srcid_regexp) { Regexp.escape("IPV4/#{current_server.address}") }
      let(:dstid_regexp) { Regexp.escape("IPV4/#{peer}") }

      it "pings peer" do
        result = current_server.ssh_exec("ping -c 1 #{peer} && echo OK")
        expect(result).to match(/OK/)
      end

      it "shows IPSec flows are established" do
        expect(current_server.ssh_exec("sudo ipsecctl -s flow")).to match(/^flow esp in from #{intranet_regexp} to #{all_regexp} peer #{peer_regexp} srcid #{srcid_regexp} dstid #{dstid_regexp} type use$/)
      end

      it "shows IPSec SAs are established" do
        expect(current_server.ssh_exec("sudo ipsecctl -s sa")).to match(/^esp tunnel from #{local_regexp} to #{peer_regexp} spi 0x[0-9a-f]+ auth hmac-sha2-256 enc aes-256$/)
        expect(current_server.ssh_exec("sudo ipsecctl -s sa")).to match(/^esp tunnel from #{peer_regexp} to #{local_regexp} spi 0x[0-9a-f]+ auth hmac-sha2-256 enc aes-256$/)
      end
    end
  end
end
