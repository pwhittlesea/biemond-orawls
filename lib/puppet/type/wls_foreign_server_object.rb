require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_foreign_server_object) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a foreign server object in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_foreign_server_object"}
      wlst template('puppet:///modules/orawls/providers/wls_foreign_server_object/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server_object/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server_object/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_foreign_server_object/destroy.py.erb', binding)
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
          /^((.*\/)?(.*):(.*):(.*)?)$/,
          [
            [ :name                     , name     ],
            [ :domain                   , optional ],
            [ :jmsmodule                , identity ],
            [ :foreign_server           , identity ],
            [ :object_name              , identity ]
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
    
      desc "The foreign server object name"
    
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
    newparam(:foreign_server) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['foreign_server']
      end
    
      desc "Foreign server name"
    
    end
    newparam(:object_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "Foreign Server Object name"
    
    end
    newproperty(:object_type) do
      include EasyType
    
      desc "The object_type of a Foreign Server object "
    
      newvalues(:destination, :connectionfactory)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['object_type']
      end
    
    end
    newproperty(:remotejndiname) do
      include EasyType
    
      desc "The Remote JNDI of the Foreign server object "
    
      to_translate_to_resource do | raw_resource|
        raw_resource['remotejndiname']
      end
    
    end
    newproperty(:localjndiname) do
      include EasyType
    
      desc "The Local JNDI of the Foreign server object "
    
      to_translate_to_resource do | raw_resource|
        raw_resource['localjndiname']
      end
    
    end
  end
end
