module Padrino
  module Generators

    class AdminApp < Thor::Group

      # Add this generator to our padrino-gen
      Padrino::Generators.add_generator(:admin, self)

      # Define the source template root
      def self.source_root; File.expand_path(File.dirname(__FILE__)); end
      def self.banner; "padrino-gen backend"; end

      # Include related modules
      include Thor::Actions
      include Padrino::Generators::Actions

      desc "Description:\n\n\tpadrino-gen controller generates a new Padrino Admin"

      class_option :root,    :aliases => '-r', :default => nil,     :type    => :string
      class_option :path,    :aliases => '-p', :type    => :string, :default => "admin"
      class_option :destroy, :aliases => '-d', :default => false,   :type    => :boolean

      # Copies over the Padrino base admin application
      def create_admin
        if in_app_root?(options[:root])
          @app_path = options[:path]
          @orm = fetch_component_choice(:orm, options[:root]).to_sym rescue :datamapper
          self.behavior = :revoke if options[:destroy]
          directory("app/", File.join(options[:path]))
          template "templates/models/account.rb.tt", app_root_path("/app/models/account.rb")
          append_file app_root_path("config/apps.rb"),  "\nPadrino.mount(\"Admin\").to(\"/#{@app_path}\")"
          say "Your admin now is installed. Setup your db data and add an account then you can login."
        else
          say "You are not at the root of a Padrino application! (config/boot.rb not found)" and exit unless in_app_root?
        end
      end

    end

  end
end