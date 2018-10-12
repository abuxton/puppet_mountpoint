require 'spec_helper'
#describe 'puppet_mountpoint' do
describe 'puppet_mountpoint', type: :define do
  let(:title) { 'namevar' }
  let(:params) do
    { 'mountpoint'        => 'namevar',
      'legacy_auth'       => 'false',
      'path'              => '/tmp/namevar',
      'auth_allow_ip'     =>  nil,
      'auth_allow'        =>  '*',
      'hocon_allow'       =>  '*',
      'fileserverconfig'  => 'etc/puppetlabs/puppet/fileserver.conf',
      'legacy_rest_auth'  => '/etc/puppetlabs/puppet/auth.conf',
      'hocon_auth'        => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
      'hocon_hash'        => {}
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
