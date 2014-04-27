require 'pathname'
require 'easy_type'
require 'utils/wls_access'
require 'utils/settings'
require 'facter'

module Puppet
  #
  newtype(:wls_server) do
    include EasyType
    include Utils::WlsAccess

    desc "This resource allows you to manage server in an WebLogic domain."

    ensurable

    set_command(:wlst)
  
    to_get_raw_resources do
      Puppet.info "index #{name} "
      environment = { "action"=>"index","type"=>"wls_server"}
      wlst template('puppet:///modules/orawls/providers/wls_server/index.py.erb', binding), environment
    end

    on_create  do | command_builder |
      Puppet.info "create #{name} "
      template('puppet:///modules/orawls/providers/wls_server/create.py.erb', binding)
    end

    on_modify  do | command_builder |
      Puppet.info "modify #{name} "
      template('puppet:///modules/orawls/providers/wls_server/modify.py.erb', binding)
    end

    on_destroy  do | command_builder |
      Puppet.info "destroy #{name} "
      template('puppet:///modules/orawls/providers/wls_server/destroy.py.erb', binding)
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
            [ :name       , name     ],
            [ :domain     , optional ],
            [ :server_name, identity ]
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
    
      desc "The server name"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource['name']
      end
    
    end
    newparam(:server_name) do
      include EasyType
      include EasyType::Validators::Name
    
      isnamevar
    
      desc "The server name"
    
    end

    newproperty(:ssllistenport) do
      include EasyType
      desc "The server ssl port"
      defaultto '7002'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['ssllistenport']
      end
    
    end
    newproperty(:sslenabled) do
      include EasyType
    
      desc "The ssl enabled on the server"
      newvalues('1', '0')
    
      to_translate_to_resource do | raw_resource|
        raw_resource['sslenabled']
      end
    
    end
    newproperty(:listenaddress) do
      include EasyType
    
      desc "The listenaddress of the server"
      defaultto ''
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['listenaddress']
      end
    
    end
    newproperty(:listenport) do
      include EasyType
      include EasyType::Mungers::Integer
    
      desc "The listenport of the server"
      defaultto 7001
    
    
      to_translate_to_resource do | raw_resource|
        raw_resource['listenport'].to_f.to_i
      end
    
    end
    newproperty(:machine) do
      include EasyType
    
      desc "The machine of the server"
     
      to_translate_to_resource do | raw_resource|
        raw_resource['machine']
      end
    
    end
    newproperty(:classpath) do
      include EasyType
    
      desc "The classpath (path on the machine running Node Manager) to use when starting this server.
    At a minimum you will need to specify the following values for the class path option: WL_HOME/server/lib/weblogic_sp.jar;WL_HOME/server/lib/weblogic.jar
    where WL_HOME is the directory in which you installed WebLogic Server on the Node Manager machine.
    The shell environment determines which character you use to separate path elements. On Windows, you typically use a semicolon (;). In a BASH shell, you typically use a colon (:)."
      
      to_translate_to_resource do | raw_resource|
        raw_resource['classpath']
      end
    
    end
    newproperty(:arguments) do
      include EasyType
    
      desc "The server arguments of the server"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['arguments']
      end
    
    end
    newproperty(:logfilename) do
      include EasyType
    
      desc "The log file name of the server"
      
      to_translate_to_resource do | raw_resource|
        raw_resource['logfilename']
      end
    
    end
    newproperty(:sslhostnameverificationignored) do
      include EasyType
    
      desc "The ssl hostname verification ignored enabled on the server"
      newvalues(1, 0)
    
      to_translate_to_resource do | raw_resource|
        raw_resource['sslhostnameverificationignored']
      end
    
    end
    newproperty(:jsseenabled) do
      include EasyType
    
      desc "The JSSE eenabled enabled on the server"
      newvalues('1', '0')
    
      defaultto '0'
    
      to_translate_to_resource do | raw_resource|
        raw_resource['jsseenabled']
      end
    
    end

  end
end
