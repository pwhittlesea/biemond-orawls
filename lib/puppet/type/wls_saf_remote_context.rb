require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_saf_remote_context) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a SAF remote contexts in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_saf_remote_context"}
      wlst template('puppet:///modules/orawls/providers/wls_saf_remote_context/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_remote_context/destroy.py.erb', binding)
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
            [ :name                       , name     ],
            [ :domain                     , optional ],
            [ :jmsmodule                  , identity ],
            [ :remote_context_name        , identity ]
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
    
      desc "The SAF remote context name"
    
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
    newparam(:remote_context_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "SAF remote context name"
    
    end
    newparam(:weblogic_password) do
      include EasyType
    
      desc "Remote WebLogic password"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['weblogic_password']
      end
    end
    newproperty(:weblogic_user) do
      include EasyType
    
      desc "the weblogic user account "
    
      to_translate_to_resource do | raw_resource|
        raw_resource['weblogic_user']
      end
    
    end
    newproperty(:connect_url) do
      include EasyType
    
      desc "The url to connect to"
      defaultto 't3://1.1.1.1:7001'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['connect_url']
      end
    
    end
  end
end
