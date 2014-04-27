require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_connection_factory) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a CF in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jms_connection_factory"}
      wlst template('puppet:///modules/orawls/providers/wls_jms_connection_factory/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_connection_factory/destroy.py.erb', binding)
    end

    def self.title_patterns
      # possible values for /^((.*\/)?(.*):(.*)?)$/
      # default/server1:channel1 with this as regex outcome 
      #    default/server1:channel1  default/ server1 channel1
      # server1:channel1 with this as regex outcome
      #    server1  nil  server1 channel1
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
          /^((.*\/)?(.*):(.*)?)$/,
          [
            [ :name                     , name     ],
            [ :domain                   , optional ],
            [ :jmsmodule                , identity ],
            [ :connection_factory_name  , identity ]
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
      include EasyType::Validators::Name
    
      desc "The CF name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
      	raw_resource['name']
      end
    
    end
    newparam(:jmsmodule) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The JMS module name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['jmsmodule']
      end
    
    end
    newparam(:connection_factory_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The Connection Factory name"
    
    end
    newproperty(:jndiname) do
      include EasyType
    
      desc "The jndiname name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['jndiname']
      end
    
    end
    newproperty(:subdeployment) do
      include EasyType
    
      desc "The subdeployment name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['subdeployment']
      end
    
    end
    newproperty(:defaulttargeting) do
      include EasyType
    
      desc "default targeting enabled on the cf"
      newvalues(1, 0)
      defaultto 1
    
      to_translate_to_resource do | raw_resource|
        raw_resource['defaulttargeting']
      end
    
    end
    newproperty(:transactiontimeout) do
      include EasyType
    
      desc "transaction timeout on the cf"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['transactiontimeout']
      end
    
    end
    newproperty(:xaenabled) do
      include EasyType
    
      desc "xa enabled on the cf"
      newvalues(1, 0)
      defaultto 1
    
      to_translate_to_resource do | raw_resource|
        raw_resource['xaenabled']
      end
    
    end
  end
end
