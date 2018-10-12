require 'spec_helper'
#describe 'puppet_mountpoint' do
describe 'puppet_mountpoint', type: :define do
  let(:title) { 'namevar' }
  let(:params) do
    { 'mountpoint'    => 'namevar',
      'path'          => '/tmp/namevar'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
