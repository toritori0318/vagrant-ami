require "vagrant"

module VagrantPlugins
  module AMI
    class Config < Vagrant.plugin("2", :config)
      # The tags for created AMIs.
      #
      # @return [Hash<String, String>]
      attr_accessor :tags

      def initialize(region_specific=false)
        @tags           = {}
      end

      def validate(machine)
        errors = _detected_errors

        errors << I18n.t("vagrant_aws.config.region_required") if @region.nil?

        if @region
          # Get the configuration for the region we're using and validate only
          # that region.
          config = get_region_config(@region)

          if !config.use_iam_profile
            errors << I18n.t("vagrant_aws.config.access_key_id_required") if \
              config.access_key_id.nil?
            errors << I18n.t("vagrant_aws.config.secret_access_key_required") if \
              config.secret_access_key.nil?
          end

          errors << I18n.t("vagrant_aws.config.ami_required") if config.ami.nil?
        end

        { "AWS Provider" => errors }
      end

      # This gets the configuration for a specific region. It shouldn't
      # be called by the general public and is only used internally.
      def get_region_config(name)
        if !@__finalized
          raise "Configuration must be finalized before calling this method."
        end

        # Return the compiled region config
        @__compiled_region_configs[name] || self
      end
    end
  end
end
