#!/usr/bin/env rspec

require 'spec_helper'

describe 'bmclib', :type => 'class' do

  context 'on a RedHat osfamily' do
    let(:params) do
      {:package_ensure => 'present' }
    end
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'RedHat'
    }
    end

    it { is_expected.to contain_package('ipmitool').with(
      :ensure => 'present'
    )}
    it { is_expected.to contain_package('ipmidriver').with(
      :ensure => 'present',
      :name   => 'OpenIPMI'
    )}
    it { is_expected.to contain_service('ipmi').with(
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
      :hasstatus  => 'true',
      :require    => [ 'Package[ipmitool]', 'Package[ipmidriver]' ]
    )}
    it { is_expected.to contain_file('/etc/sysconfig/ipmi').with(
      :ensure  => 'present',
      :path    => '/etc/sysconfig/ipmi',
      :notify  => 'Service[ipmi]'
    )}
#    it 'should contain File[/etc/sysconfig/ipmi] with correct contents' do
#      verify_contents(subject, '/etc/sysconfig/ipmi', [
#        '',
#      ])
#    end
  end

  context 'on a Debian osfamily' do
    let(:params) do
      {:package_ensure => 'present' }
    end
    let :facts do {
      :osfamily        => 'Debian',
      :operatingsystem => 'Debian'
    }
    end

    it { is_expected.to contain_package('ipmitool').with(
      :ensure => 'present'
    )}
    it { is_expected.to contain_package('ipmidriver').with(
      :ensure => 'present',
      :name   => 'openipmi'
    )}
    it { is_expected.to contain_service('openipmi').with(
      :ensure     => 'running',
      :enable     => 'true',
      :hasrestart => 'true',
      :hasstatus  => 'true',
      :require    => [ 'Package[ipmitool]', 'Package[ipmidriver]' ]
    )}
    it { is_expected.to contain_file('/etc/default/ipmi').with(
      :ensure  => 'present',
      :path    => '/etc/default/ipmi',
      :content => 'ENABLED=true',
      :notify  => 'Service[openipmi]'
    )}
  end

end
