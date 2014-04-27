require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jms_queue) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a Queue in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jms_queue"}
      wlst template('puppet:///modules/orawls/providers/wls_jms_queue/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_queue/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_queue/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jms_queue/destroy.py.erb', binding)
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
            [ :queue_name  , identity ]
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
    
      desc "The queue name"
    
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
    newparam(:queue_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The queue name"
    
    end
    newproperty(:distributed) do
      include EasyType
      include EasyType::Mungers::Integer
    
      desc "Distributed queue"
      newvalues(1,0)
      defaultto 0
    
      to_translate_to_resource do | raw_resource|
        raw_resource['distributed']
      end
    
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
    newproperty(:balancingpolicy) do
      include EasyType
    
      desc "balancingpolicy of the distributed queue"
    
      newvalues(:'Round-Robin', :'Random')
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['balancingpolicy']
      end
    
    end
    newproperty(:quota) do
      include EasyType
    
      desc "quota of the queue"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['quota']
      end
    
    end
    newproperty(:defaulttargeting) do
      include EasyType
    
      desc "default targeting enabled on the queue"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['defaulttargeting']
      end
    
    end
    newproperty(:errordestination) do
      include EasyType
    
      desc "errordestination of the queue"
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['errordestination']
      end
    
    end
    newproperty(:expirationloggingpolicy) do
      include EasyType
    
      desc "expirationloggingpolicy of the queue"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['expirationloggingpolicy']
      end
    
    end
    newproperty(:redeliverylimit) do
      include EasyType
      include EasyType::Mungers::Integer
    
      defaultto -1
    
      desc "redeliverylimit of the queue"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['redeliverylimit'].to_f.to_i
      end
    
    end
    newproperty(:expirationpolicy) do
      include EasyType
    
      desc "expirationpolicy of the queue"
    
      newvalues(:'Discard', :'Log',:'Redirect')
    
      defaultto 'Discard'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['expirationpolicy']
      end
    
    end
    newproperty(:redeliverydelay) do
      include EasyType
      include EasyType::Mungers::Integer
    
      defaultto -1
    
      desc "redeliverydelay of the queue"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['redeliverydelay'].to_f.to_i
      end
    
    end
    newproperty(:timetodeliver) do
      include EasyType
      include EasyType::Mungers::Integer
    
      defaultto -1
    
      desc "timetodeliver of the queue"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['timetodeliver'].to_f.to_i
      end
    
    end
    newproperty(:timetolive) do
      include EasyType
      include EasyType::Mungers::Integer
    
      defaultto -1
    
      desc "timetolive of the queue"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['timetolive'].to_f.to_i
      end
    
    end
  end
end
