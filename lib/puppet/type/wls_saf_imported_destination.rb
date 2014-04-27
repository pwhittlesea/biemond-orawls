require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_saf_imported_destination) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage a SAF imported destinations in a JMS Module of an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name}"
      environment = { "action"=>"index","type"=>"wls_saf_imported_destination"}
      wlst template('puppet:///modules/orawls/providers/wls_saf_imported_destination/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_imported_destination/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_imported_destination/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_saf_imported_destination/destroy.py.erb', binding)
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
            [ :imported_destination_name  , identity ]
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
    newparam(:imported_destination_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "SAF imported destination name"
    
    end
    newproperty(:errorhandling) do
      include EasyType
    
      desc "the SAF Error Handling of this SAF imported destination"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['errorhandling']
      end
    
    end
    newproperty(:remotecontext) do
      include EasyType
    
      desc "the SAF Remote Context of this SAF imported destination"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['remotecontext']
      end
    
    end
    newproperty(:jndiprefix) do
      include EasyType
    
      desc "the SAF JNDI prefix of this SAF imported destination"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['jndiprefix']
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
    newproperty(:defaulttargeting) do
      include EasyType
    
      desc "default targeting enabled"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['defaulttargeting']
      end
    
    end
    newproperty(:subdeployment) do
      include EasyType
    
      desc "The subdeployment name"
    
      to_translate_to_resource do | raw_resource|
        raw_resource['subdeployment']
      end
    
    end

   end
end
