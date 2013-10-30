require "thor"
require "io/console"
require "yaml"
require_relative "../bucket"

module Bucket
  class CLI < Thor
    def initialize(*args)
      super

      @client = Bucket::Client.new load_config
    end

    desc "setup", "Setup your BitBucket credentials"
    def setup
      generate_config

      say("Configuration saved to ~/.bucket")
    end

    desc "repos", "List your own repositories"
    def repos
      @client.repos_list.each do |repo|
        say("#{repo.owner}/#{repo.slug}")
      end
    end

    desc "clone", "Clone repository USER/NAME from bitbucket"
    def clone(user, name)
      `git clone #{@client.repo_url(user, name)}`
    end

    private
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

      { "username" => username, "password" => password }
    end
  end
end