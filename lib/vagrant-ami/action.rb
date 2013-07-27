require "pathname"

require "vagrant/action/builder"
require "vagrant-aws/action"

module VagrantPlugins
  module AMI
    module Action
      # Include the built-in modules so we can use them as top-level things.
      include Vagrant::Action::Builtin

      # This action is called to create EC2 AMIs.
      def self.action_create_ami
        Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use VagrantPlugins::AWS::Action::ConnectAWS
          b.use CreateAMI
        end
      end


      # The autoload farm
      action_root = Pathname.new(File.expand_path("../action", __FILE__))
      autoload :CreateAMI, action_root.join("create_ami")
    end
  end
end
