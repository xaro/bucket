require "thor"
require "io/console"
require "yaml"
require_relative "../bucket"

module Bucket
  class CLI < Thor
    def initialize(*args)
      super

      authenticate! 
    end

    desc "setup", "setup"
    def setup
      authenticate!
    end

    private
    def authenticate!
      @client = Bucket::Client.new load_config
    end

    def load_config
      YAML.load_file("#{Dir.home}/.bucket")
    rescue
      generate_config
    end

    def generate_config
      save_config ask_credentials
    end

    def save_config(credentials)
      File.open "#{Dir.home}/.bucket", 'w' do |f|
        YAML.dump(credentials , f)
      end

      credentials
    end

    def ask_credentials
      username = @shell.ask("Username:")
      @shell.say("Password: ")
      password = $stdin.noecho(&:gets).strip
      @shell.say("")

      { username: username, password: password }
    end
  end
end