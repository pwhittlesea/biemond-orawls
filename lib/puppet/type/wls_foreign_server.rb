require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_foreign_server) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage foreign servers in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_foreign_server"}
      wlst template('puppet:///modules/orawls/providers/wls_foreign_server/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server/destroy.py.erb', binding)
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
            [ :foreign_server_name      , identity ]
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
    
      desc "The foreign server name"
    
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
    newparam(:foreign_server_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "Foreign Server name"
    
    end
    newparam(:password) do
      include EasyType
    
      desc "The Foreign Server user's password"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['password']
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
    
      desc "default targeting enabled"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['defaulttargeting']
      end
    
    end
    newproperty(:extraproperties) do
      include EasyType
    
      desc "The extra foreign server properties"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['extraproperties']
      end
    
    end
    newproperty(:extraproperties) do
      include EasyType
    
      desc "The extra foreign server properties"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['extraproperties']
      end
    
    end
    newproperty(:initialcontextfactory) do
      include EasyType
    
      desc "The initial contextfactory"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['initialcontextfactory']
      end
    
    end
    newproperty(:connectionurl) do
      include EasyType
    
      desc "The connectionurl"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['connectionurl']
      end
    
    end

  end
end
