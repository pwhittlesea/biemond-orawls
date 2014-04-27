require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_saf_imported_destination_object) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a SAF imported destinations object in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_saf_imported_destination_object"}
      wlst template('puppet:///modules/orawls/providers/wls_saf_imported_destination_object/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_imported_destination_object/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_imported_destination_object/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_imported_destination_object/destroy.py.erb', binding)
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
            [ :imported_destination     , identity ],
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
    
      desc "The SAF imported destination name"
    
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
    newparam(:imported_destination) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['imported_destination']
      end
    
    
      desc "SAF imported destination name"
    
    end
    newparam(:object_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "SAF imported destination Object name"
    
    end
    newproperty(:object_type) do
      include EasyType
    
      desc "The object_type of the SAF imported destination object "
    
      newvalues(:queue, :topic)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['object_type']
      end
    
    end
    newproperty(:timetolivedefault) do
      include EasyType
    
      desc "the SAF time to live default of this SAF imported destination"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['timetolivedefault']
      end
    
    end
    newproperty(:usetimetolivedefault) do
      include EasyType
    
      desc "use time to live default of this SAF imported destination"
    
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['usetimetolivedefault']
      end
    
    end
    newproperty(:unitoforderrouting) do
      include EasyType
    
      desc "The unit of order routing of the SAF imported destination object "
    
      newvalues(:Hash, :PathService)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['unitoforderrouting']
      end
    
    end
    newproperty(:remotejndiname) do
      include EasyType
    
      desc "The Remote JNDI of the SAF imported destination object "
    
      to_translate_to_resource do | raw_resource|
        raw_resource['remotejndiname']
      end
    
    end
    newproperty(:localjndiname) do
      include EasyType
    
      desc "The Local JNDI of the SAF imported destination object "
    
      to_translate_to_resource do | raw_resource|
        raw_resource['localjndiname']
      end
    
    end
    newproperty(:nonpersistentqos) do
      include EasyType
    
      desc "The QoS non persistent of the SAF imported destination object "
    
      newvalues(:"Exactly-Once", :"At-Least-Once",:"At-Most-Once")
    
      to_translate_to_resource do | raw_resource|
        raw_resource['nonpersistentqos']
      end
    
    end

  end
end
