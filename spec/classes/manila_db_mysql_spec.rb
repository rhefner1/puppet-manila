require 'spec_helper'

describe 'manila::db::mysql' do

  let :req_params do
    {:password => 'pw',
     :mysql_module => '2.2'}
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  let :pre_condition do
    'include mysql::server'
  end

  describe 'with only required params' do
    let :params do
      req_params
    end
    it { should contain_mysql__db('manila').with(
      :user         => 'manila',
      :password     => 'pw',
      :host         => '127.0.0.1',
      :charset      => 'utf8'
     ) }
  end
  describe "overriding allowed_hosts param to array" do
    let :params do
      {
        :password       => 'manilapass',
        :allowed_hosts  => ['127.0.0.1','%']
      }
    end

    it {should_not contain_manila__db__mysql__host_access("127.0.0.1").with(
      :user     => 'manila',
      :password => 'manilapass',
      :database => 'manila'
    )}
    it {should contain_manila__db__mysql__host_access("%").with(
      :user     => 'manila',
      :password => 'manilapass',
      :database => 'manila'
    )}
  end
  describe "overriding allowed_hosts param to string" do
    let :params do
      {
        :password       => 'manilapass2',
        :allowed_hosts  => '192.168.1.1'
      }
    end

    it {should contain_manila__db__mysql__host_access("192.168.1.1").with(
      :user     => 'manila',
      :password => 'manilapass2',
      :database => 'manila'
    )}
  end

  describe "overriding allowed_hosts param equals to host param " do
    let :params do
      {
        :password       => 'manilapass2',
        :allowed_hosts  => '127.0.0.1'
      }
    end

    it {should_not contain_manila__db__mysql__host_access("127.0.0.1").with(
      :user     => 'manila',
      :password => 'manilapass2',
      :database => 'manila'
    )}
  end
end
