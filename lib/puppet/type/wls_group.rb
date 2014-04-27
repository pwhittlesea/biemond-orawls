require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_group) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage group in an WebLogic Secuirty Realm."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_group"}
      wlst template('puppet:///modules/orawls/providers/wls_group/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_group/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_group/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_group/destroy.py.erb', binding)
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
            [ :name     , name     ],
            [ :domain   , optional ],
            [ :group_name, identity ]
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
    
      desc "The group name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['name']
      end
    
    end
    newparam(:group_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The group name"
    
    end
    newproperty(:realm) do
      include EasyType
    
      desc "The security realm of the domain"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['realm']
      end
    
    end
    newproperty(:authenticationprovider) do
      include EasyType
    
      desc "The security authentication providers of the domain"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['authenticationprovider']
      end
    
    end
    newproperty(:users) do
      include EasyType
    
      desc "The users of a group"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['users']
      end
    
    end
    newproperty(:description) do
      include EasyType
    
      desc "The group description"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['description']
      end
    
    end
  end
end
