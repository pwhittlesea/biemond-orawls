require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_saf_error_handler) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a SAF Error Handler in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_saf_error_handler"}
      wlst template('puppet:///modules/orawls/providers/wls_saf_error_handler/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_error_handler/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_error_handler/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_error_handler/destroy.py.erb', binding)
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
            [ :name                , name     ],
            [ :domain              , optional ],
            [ :jmsmodule           , identity ],
            [ :error_handler_name  , identity ]
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
    
      desc "The SAF Error handler name"
    
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
    newparam(:error_handler_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "SAF error handler name"
    
    end
    newproperty(:errordestination) do
      include EasyType
    
      desc "errordestination of the queue"
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['errordestination']
      end
    
    end
    newproperty(:logformat) do
      include EasyType
    
      desc "logformat of the SAF imported destination"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['logformat']
      end
    
    end
    newproperty(:policy) do
      include EasyType
    
      desc "policy of the SAF imported destination"
    
      newvalues(:'Discard', :'Log',:'Redirect',:'Always-forward')
    
      defaultto 'Discard'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['policy']
      end
    
    end
  end
end
