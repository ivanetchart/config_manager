require "singleton"
require "forwardable"
require "yaml"

require "config_manager/version"

module ConfigManager
  class YAML
    include Singleton
    extend  SingleForwardable

    attr_reader :environment, :configs

    def_delegators :instance, :settings, :load, :environment

    DEFAULT_CONFIG_DIR = File.expand_path("../config", __dir__)

    def initialize
      @environment = :development
      @configs     = { }
      @config_dir  = DEFAULT_CONFIG_DIR
    end

    # Set the instance properties
    #
    def settings(dir:, environment: :development)
      @environment = environment
      @configs     = { }
      @config_dir  = dir
    end

    # Get a config namespace
    #
    # @param [String] key
    def self.get(key)
      instance.configs[key]
    end

    # Load configuration files into a given namespace
    #
    # @param [Array<String>] namespaces
    def load(*namespaces)
      namespaces.each do |namespace|
        @configs[namespace] ||= ::YAML.load_file(File.join(@config_dir,
          "#{namespace}.yml"))[@environment.to_s]
      end
    end
  end
end
