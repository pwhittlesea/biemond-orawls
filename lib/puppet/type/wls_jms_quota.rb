require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_quota) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a Quota in a JMS module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jms_quota"}
      wlst template('puppet:///modules/orawls/providers/wls_jms_quota/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create"
      template('puppet:///modules/orawls/providers/wls_jms_quota/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify"
      template('puppet:///modules/orawls/providers/wls_jms_quota/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy"
      template('puppet:///modules/orawls/providers/wls_jms_quota/destroy.py.erb', binding)
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
            [ :jmsmodule   , identity ],
            [ :quota_name  , identity ]
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
    
      desc "The quota name"
    
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
    newparam(:quota_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The quota name"
    
    end
    newproperty(:bytesmaximum) do
      include EasyType
    
      desc "Quota Bytes Maximum"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['bytesmaximum']
      end
    
    end
    newproperty(:messagesmaximum) do
      include EasyType
    
      desc "Maximum messages"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['messagesmaximum']
      end
    
    end
    newproperty(:policy) do
      include EasyType
    
      desc "policy name of the Quota"
    
      newvalues('FIFO','PREEMPTIVE')
      
      to_translate_to_resource do | raw_resource|
        raw_resource['policy']
      end
    
    end
    newproperty(:shared) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "Shared Quota"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['shared']
      end
    
    end

  end
end
