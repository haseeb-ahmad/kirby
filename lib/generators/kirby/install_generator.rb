module Kirby
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def create_initializer_file
      return if Rails.env.production?
      template 'config/initializers/kirby.rb'
    end


    def add_route
      return if Rails.env.production?
      return if Rails.application.routes.routes.detect { |route| route.app.app == Kirby::Engine }
      route "mount Kirby::Engine => '/'"
    end

    def copy_migrations
      return if Rails.env.production?
      rake 'kirby:install:migrations'
    end

    def run_migrations
      rake 'db:migrate'
    end

    def create_account
      return if Account.exists? && !no?('An account already exists. Skip? [Yn]')
      name = Account.first.try(:name) || 'MySite'
      name = ask("What would you like to name your website? [#{name}]").presence || name
      account = Account.first_or_create.update_attribute(:name, name)
    end

    def set_theme
      account = Account.first
      return if account.theme.present? && !no?("Theme '#{account.theme} is set. Skip? [Yn]")

      theme = begin
        theme = account.theme || themes.first
        theme = ask("What theme do you want to use? (#{themes.join('/')}) [#{theme}]").presence || theme
      end until theme.in? themes

      account.update_attribute(:theme, theme)
    end

    def copy_template_files
      theme = Account.first.theme
      if theme.in? ['default', 'demo']
        template "config/initializers/themes/#{theme}.rb"
        directory "app/assets/stylesheets/#{theme}"
        directory "app/views/#{theme}"
        directory "app/views/layouts/#{theme}"
      end
      Kirby::THEMES.clear
      Dir[Rails.root.join('config', 'initializers', 'themes', '*.rb')].each { |file| load file }
    end

    def create_user
      return if User.exists? && !no?('A user already exists. Skip? [Yn]')
      email = 'admin@domain.com'
      email = ask("Please enter an email address for your first user: [#{email}]").presence || email
      password = 'password'
      password = ask("Create a temporary password: [#{password}]").presence || password
      @temporary_password = password
      User.create name: 'admin', email: email, password: password, admin: true
    end

    def bootstrap_kirby
      rake 'kirby:bootstrap'
    end

    def feedback
      puts
      puts '    Your Kirby site has been succesfully installed! '
      puts
      puts '    Restart your server and visit http://localhost:3000 in your browser!'
      puts "    The admin backend is located at http://localhost:3000/#{Kirby.config.backend_path}."
      puts
      puts "    Site name      :  #{Account.first.name}"
      puts "    Active theme   :  #{Account.first.theme}"
      puts "    User email     :  #{User.first.email}"
      puts "    User password  :  #{@temporary_password}"
      puts
    end

    private

    def themes
      themes = Kirby::Theme.all.map(&:name)
      themes | ['default', 'demo']
    end

  end
end
