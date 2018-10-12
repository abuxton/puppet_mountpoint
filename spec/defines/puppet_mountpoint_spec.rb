require 'spec_helper'
describe 'puppet_mountpoint', type: :define do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:params) do
        { 'mountpoint'        => 'test',
          'legacy_auth'       => 'false',
          'path'              => '/tmp/namevar',
          'auth_allow_ip'     =>  nil,
          'auth_allow'        =>  '*',
          'hocon_allow'       =>  '*',
          'fileserverconfig'  => 'etc/puppetlabs/puppet/fileserver.conf',
          'legacy_rest_auth'  => '/etc/puppetlabs/puppet/auth.conf',
          'hocon_auth'        => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
          'hocon_hash'        => {},
          'settings::fileserverconfig' => '',
          'settings::rest_authconfig' => '' }
      end

      it { is_expected.to compile }
    end
  end
end
