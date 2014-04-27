require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_server_channel) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage server in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_server_channel"}
      wlst template('puppet:///modules/orawls/providers/wls_server_channel/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server_channel/destroy.py.erb', binding)
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
            [ :name        , name     ],
            [ :domain      , optional ],
            [ :server      , identity ],
            [ :channel_name, identity ]
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
    newparam(:server) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The server name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['server']
      end
    
    end
    newparam(:channel_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "Server channel name"
    
    end

    newproperty(:protocol) do
      include EasyType
    
      desc "The server channel protocol"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['protocol']
      end
    
    end
    newproperty(:enabled) do
      include EasyType
    
      desc "The channel enabled on the server"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['enabled']
      end
    
    end
    newproperty(:listenport) do
      include EasyType
    
      desc "The channel listenport of the server"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['listenport']
      end
    
    end
    newproperty(:listenaddress) do
      include EasyType
    
      desc "The listenaddress of the server channel"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['listenaddress']
      end
    
    end
    newproperty(:publicaddress) do
      include EasyType
    
      desc "The public address of the server channel"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['publicaddress']
      end
    
    end
    newproperty(:httpenabled) do
      include EasyType
    
      desc "The channel HTTP enabled on the server"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['httpenabled']
      end
    
    end
    newproperty(:outboundenabled) do
      include EasyType
    
      desc "The channel outbound enabled on the server"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['outboundenabled']
      end
    
    end
    newproperty(:tunnelingenabled) do
      include EasyType
    
      desc "The channel tunneling enabled on the server"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['tunnelingenabled']
      end
    
    end

  end
end
