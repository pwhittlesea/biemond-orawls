require 'easy_type'
require 'yaml'
#require 'ruby-debug'

module Puppet
  newtype(:wls_setting) do
    include EasyType

    DEFAULT_FILE = "/etc/wls_setting.yaml"

    desc "This resource allows you to set the defaults for all other wls types"

    to_get_raw_resources do
      resources_from_yaml
    end

    newparam(:name) do
      include EasyType
    
      desc "The name of the setting"
    
      isnamevar
    
      to_translate_to_resource do | raw_resource|
        raw_resource[self.name]
      end
    
    end
    newproperty(:user) do
      include EasyType
    
      desc "Operating System user"
      defaultto 'oracle'
    
      to_translate_to_resource do | raw_resource|
        raw_resource[self.name]
      end
    
    end
    newproperty(:weblogic_home_dir) do
      include EasyType
    
      desc "The WLS homedir"
    
      to_translate_to_resource do | raw_resource|
        raw_resource[self.name]
      end
    
    end
    newproperty(:weblogic_user) do
      include EasyType
    
      desc "the weblogic user account "
      defaultto 'weblogic'
    
      to_translate_to_resource do | raw_resource|
        raw_resource[self.name]
      end
    
    end
    newproperty(:connect_url) do
      include EasyType
    
      desc "The url to connect to"
      defaultto 't3://localhost:7001'
    
      to_translate_to_resource do | raw_resource|
        raw_resource[self.name]
      end
    
    end
    newproperty(:weblogic_password) do
      include EasyType
    
      desc "TODO: Fill in the description"
      defaultto 'weblogic1'
    
      to_translate_to_resource do | raw_resource|
        raw_resource[self.name]
      end
    end

    def self.configuration
      @configuration
    end

  private

    def self.resources_from_yaml
      Puppet.info "0 read_from_yaml "
      @configuration = read_from_yaml
      normalize(@configuration)
    end

    def self.config_file
      Pathname.new(DEFAULT_FILE).expand_path
    end

    def self.read_from_yaml
      if File.exists?(config_file)
        open(config_file){|f| YAML.load(f)}
      else
        Hash['default', {}]
      end
    end

    private

      def self.normalize(content)
        normalized_content = []
        content.each do | key, value|
          value[:name] = key
          normalized_content << with_hashified_keys(value)
        end
        normalized_content
      end

      def self.with_hashified_keys(hash)
        result = {}
        hash.each do |key, value|
          result[key.to_sym] = value 
        end
        result
      end

  end
end
