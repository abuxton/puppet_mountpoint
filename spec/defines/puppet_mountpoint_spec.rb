require 'spec_helper'
describe 'puppet_mountpoint', type: :define do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:title) { 'test' }
      let(:params) do
        { 'mountpoint'        => 'test',
          'legacy_auth'       => false,
          'path'              => '/tmp/namevar',
          'auth_allow_ip'     =>  :undef,
          'auth_allow'        =>  '*',
          'hocon_allow'       =>  '*', }
      end

      it { is_expected.to compile }
    end
  end
end
