require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_cluster) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a cluster in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_cluster"}
      wlst template('puppet:///modules/orawls/providers/wls_cluster/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_cluster/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_cluster/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_cluster/destroy.py.erb', binding)
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
            [ :name        , name     ],
            [ :domain      , optional ],
            [ :cluster_name, identity ]
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
    
      desc "The cluster name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['name']
      end
    
    end
    newparam(:cluster_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The cluster name"
    
    end
    newproperty(:servers) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The nodes which are part of this cluster"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['servers']
      end
    
    end
    newproperty(:migrationbasis) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The migrationbasis of this cluster"
    
      defaultto 'consensus'
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['migrationbasis']
      end
    
    end
    newproperty(:migration_datasource) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The migration datasource of this cluster when database leasing is used"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['migration_datasource']
      end
    
    end
    newproperty(:migration_table_name) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The migration table name of this cluster when database leasing is used"
    
      defaultto 'ACTIVE'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['migration_table_name']
      end
    
    end
    newproperty(:messagingmode) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The messagingmode of this cluster"
    
      defaultto 'unicast'
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['messagingmode']
      end
    
    end
    newproperty(:datasourceforjobscheduler) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The DataSource For JobScheduler which are part of this cluster"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['datasourceforjobscheduler']
      end
    
    end
    
    newproperty(:unicastbroadcastchannel) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The unicast broadcast channel of this cluster"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['unicastbroadcastchannel']
      end
    
    end
    
    newproperty(:multicastaddress) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The multi cast address of this cluster"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['multicastaddress']
      end
    
    end
    
    newproperty(:multicastport) do
      include EasyType
      include EasyType::Validators::Name
    
      desc "The multi cast port of this cluster"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['multicastport']
      end
    
    end
    
  end
end
