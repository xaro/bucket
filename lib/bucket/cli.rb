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
      get_oauth
    end

    private
    def authenticate!
      @client = Bucket::Client.new get_oauth
    end

    def get_oauth
      load_config
    end

    def load_config
      YAML.load_file("#{Dir.home}/.bucket")
    rescue
      generate_config
    end

    def generate_config
      save_config generate_oauth_key
    end

    def save_config(oauth)
      File.open "#{Dir.home}/.bucket", 'w' do |f|
        YAML.dump(oauth , f)
      end

      oauth
    end

    def ask_credentials
      username = @shell.ask("Username:")
      @shell.say("Password: ")
      password = $stdin.noecho(&:gets).strip
      @shell.say("")

      "#{username}:#{password}"
    end

    def generate_oauth_key
      bitbucket = BitBucket.new(basic_auth: ask_credentials)  
      resp = bitbucket.post_request("/users/#{bitbucket.login}/consumers", name: 'bucket')

      {
        key: resp["key"],
        secret: resp["secret"]
      }
    end
  end
end