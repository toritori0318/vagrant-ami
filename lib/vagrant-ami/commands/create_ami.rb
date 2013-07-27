require 'optparse'

module VagrantPlugins
  module AMI
    class Command < Vagrant.plugin("2", :command)
      def execute

        options = {
            :tags => {}
        }

        opts = OptionParser.new do |o|
          o.banner = "Usage: vagrant create_ami [vm-name]"
          o.separator ""

          o.on("-n", "--name NAME", "AMI Name") do |n|
            options[:name] = n
          end

          o.on("-d", "--desc DESCRIPTION", "AMI Description.") do |d|
            options[:desc] = d
          end

          o.on("-t", "--tags key1=val1,keyN=valN", Array, "Optional tags to assign to the AMI.") do |t|
            options[:tags] = Hash[t.map {|kv| kv.split("=")}]
          end

          # TODO add option to wait until AMI creation is complete?
          # TODO does this work if the instance is terminated immediately after hte create_ami call
          # is issues?

        end

        # Parse the options
        argv = parse_options(opts)
        return if !argv
        
        if options[:name].nil? or options[:desc].nil?
          raise Vagrant::Errors::CLIInvalidOptions, :help => opts.help.chomp
        end

        with_target_vms(argv, :reverse => true) do |machine|
          @env.action_runner.run(VagrantPlugins::AMI::Action.action_create_ami, {
            :machine    => machine,
            :name       => options[:name],
            :desc       => options[:desc],
            :tags       => options[:tags]
          })
        end
        0
      end
    end
  end
end
