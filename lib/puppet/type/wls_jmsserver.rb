require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_jmsserver) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a jmsserver in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_jmsserver"}
      wlst template('puppet:///modules/orawls/providers/wls_jmsserver/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_jmsserver/destroy.py.erb', binding)
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
            [ :name          , name     ],
            [ :domain        , optional ],
            [ :jmsserver_name, identity ]
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
    
      desc "The jmsserver name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['name']
      end
    
    end
    newparam(:jmsserver_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The jmsserver_name name"
    
    end
    newproperty(:persistentstore) do
      include EasyType
    
      desc "The persistentstore name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['persistentstore']
      end
    
    end
    newproperty(:persistentstore) do
      include EasyType
    
      desc "The persistentstore name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['persistentstore']
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
