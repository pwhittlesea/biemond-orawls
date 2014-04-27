require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_virtual_host) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage virtual host in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_virtual_host"}
      wlst template('puppet:///modules/orawls/providers/wls_virtual_host/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_host/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_host/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_virtual_host/destroy.py.erb', binding)
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
          /^((.*\/)?(.*)?)$/,
          [
            [ :name             , name     ],
            [ :domain           , optional ],
            [ :virtual_host_name, identity ]
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
    
      desc "The server channel name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['name']
      end
    
    end
    newparam(:virtual_host_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The virtual host name"
    
    
    end
    newproperty(:channel) do
      include EasyType
    
      desc "Server channel name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['channelname']
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

  end
end