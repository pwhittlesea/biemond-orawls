require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_datasource) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a datasource in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_datasource"}
      wlst template('puppet:///modules/orawls/providers/wls_datasource/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_datasource/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_datasource/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_datasource/destroy.py.erb', binding)
    end

    def self.title_patterns
      # possible values for /^((.*\/)?(.*)?)$/
      # default/testuser1 with this as regex outcome 
      #    default/testuser1 default/ testuser1
      # testuser1 with this as regex outcome
      #    testuser1  nil  testuser1
      identity  = lambda {|x| x}
      name      = lambda {|x| 
          if x.include? "/"
            x            # it contains a domain
          else
            'default/'+x # add the default domain
          end
        }
      optional  = lambda{ |x| 
          if x.nil?
            'default' # when not found use default
          else
            x[0..-2]  # remove the last char / from domain name
          end
        }
      [
        [
          /^((.*\/)?(.*)?)$/,
          [
            [ :name           , name     ],
            [ :domain         , optional ],
            [ :datasource_name, identity ]
          ]
        ],
        [
          /^([^=]+)$/,
          [
            [ :name, identity ]
          ]
        ]
      ]
    end

    newparam(:domain) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "Domain name"
    
      defaultto 'default'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['domain']
      end
    
    end
    newparam(:name) do
      include EasyType
    
      desc "The datasource name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['name']
      end
    
    end
    newparam(:datasource_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The datasource  name"
    
    end

    newparam(:password) do
      include EasyType
    
      desc "The database user's password"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['password']
      end
    
    end
    newproperty(:target) do
      include EasyType
    
      desc "The target name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['target']
      end
    
    end
    newproperty(:target) do
      include EasyType
    
      desc "The target name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['target']
      end
    
    end
    newproperty(:jndinames) do
      include EasyType
    
      desc "The datasource jndi names"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['jndinames']
      end
    
    end
    newproperty(:drivername) do
      include EasyType
    
      desc "The drivername"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['drivername']
      end
    
    end
    newproperty(:url) do
      include EasyType
    
      desc "The jdbc url"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['url']
      end
    
    end
    newproperty(:usexa) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The UseXaDataSourceInterface enabled on the jdbc driver"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['usexa']
      end
    
    end
    newproperty(:user) do
      include EasyType
    
      desc "The datasource user name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['user']
      end
    
    end
    newproperty(:testtablename) do
      include EasyType
    
      desc "The test table statement for the datasource"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['testtablename']
      end
    
    end
    newproperty(:globaltransactionsprotocol) do
      include EasyType
    
      desc "The global Transactions Protocol"
      newvalues('TwoPhaseCommit','EmulateTwoPhaseCommit','OnePhaseCommit','None')
      defaultto 'TwoPhaseCommit'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['globaltransactionsprotocol']
      end
    
    end
    newproperty(:extraproperties) do
      include EasyType
    
      desc "The extra datasource properties"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['extraproperties']
      end
    
    end
    newproperty(:extraproperties) do
      include EasyType
    
      desc "The extra datasource properties"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['extraproperties']
      end
    
    end
    newproperty(:maxcapacity) do
      include EasyType
    
      desc "The max capacity of the datasource"
    
      defaultto '15'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['maxcapacity']
      end
    
    end
    newproperty(:initialcapacity) do
      include EasyType
    
      desc "The initial capacity of the datasource"
    
      defaultto '1'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['initialcapacity']
      end
    
    end
  end
end
