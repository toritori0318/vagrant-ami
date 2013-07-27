require 'date'
require 'vagrant-aws/util/timer'
require 'vagrant-aws/errors'
require 'vagrant/util/retryable'

module VagrantPlugins
  module AMI
    module Action
      # This runs the configured instance.
      class CreateAMI
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_ami::action::create_ami")
        end

        def call(env)
          if env[:machine].state.id != :running
            puts "Skipping #{env[:machine].name}: not running"
          else
            _create_ami(env)
          end

        end

        protected

        def _create_ami(env)
            env[:ui].info("Creating AMI named '#{env[:name]}'for #{env[:machine].name} (#{env[:machine].id})")

            # TODO this isn't getting logged
            @logger.info("Description: #{env[:desc]} Tags: #{env[:tags]}")

            # TODO error handling on create_image/tags
            # this raises an error if AMI name already exists
            # see this for error handling examples
            # https://github.com/mitchellh/vagrant-aws/blob/master/lib/vagrant-aws/action/run_instance.rb#L79
            server = env[:aws_compute].servers.get(env[:machine].id)
            begin
              data = env[:aws_compute].create_image(server.identity, env[:name], env[:desc])
            rescue Excon::Errors::BadRequest => e
              if e.response.body =~ /InvalidAMIName.Duplicate/ 
                raise VagrantPlugins::AWS::Errors::FogError,
                  :message => "An AMI named #{env[:name]} already exists"
              end
              raise
            end

            image_id = data.body["imageId"]

            image = env[:aws_compute].images.get(image_id)
            env[:ui].info("Creating #{image_id}")

            # Wait for the image to be ready
            # TODO should have a configurable timeout for this
            while true
              # If we're interrupted then just back out
              break if env[:interrupted]
              image = env[:aws_compute].images.get(image_id)
              break if image.ready?
              sleep 2
            end

            unless env[:tags].empty?
              env[:ui].info("Adding tags to AMI")
              env[:aws_compute].create_tags(image_id, env[:tags])
            end
            env[:ui].info("Created #{image_id}")
        end
      end
    end
  end
end
