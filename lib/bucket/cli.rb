require "thor"
require "io/console"
require "yaml"
require "git"
require_relative "../bucket"

module Bucket
  class CLI < Thor
    include Thor::Actions

    CONFIG_FILE_PATH = "#{Dir.home}/.bucket"

    def initialize(*args)
      super

      @client = Bucket::Client.new(load_config)
    end

    desc "setup", "Setup your BitBucket credentials"
    def setup
      generate_config

      say("Configuration saved to ~/.bucket")
    end

    desc "repos", "List your own repositories."
    def repos
      @client.repos_list.each do |repo|
        say(@client.repo_full_name(repo))
      end
    end

    desc "clone [USER]/REPOSITORY", "Clone repository REPOSITORY from bitbucket.\nIf [USER] is ommited, it is assumed that it's your BitBucket user."
    def clone(name)
      begin
        repository = Git::Base.clone(@client.repo_url(name), name)
        say("Repository cloned to #{repository.dir}")
      rescue Git::GitExecuteError => e
        say("Could not clone repository")
        say(e.message)
      end
    end

    desc "init DIRECTORY", "Create a new repository locally and on BitBucket."
    option :name, desc: "The name of the repository. If not specified, the current folder will be used."
    option :description, desc: "A description for the repository."
    option :public, desc: "Sets if the repository is public or private.", type: :boolean, default: false
    def init(directory)
      repository = @client.init(directory, options)

      say("Repository with remote #{repository.remote("BitBucket").url} created.")
    end

    private
    # Loads the configuration from the config file.
    # If it does not exists, it creates it.
    def load_config
      YAML.load_file(CONFIG_FILE_PATH)
    rescue
      generate_config
    end

    def generate_config
      save_config(ask_credentials)
    end

    # Saves the configuration to the config file, and returns
    # the config.
    def save_config(credentials)
      File.open CONFIG_FILE_PATH, 'w', 0600 do |f|
        YAML.dump(credentials , f)
      end

      credentials
    end

    def ask_credentials
      username = ask("Username:")

      # Avoid echoing the password
      password = ask("Password:", echo: false)

      say("\nWARNING: For now, the password is saved IN PLAIN TEXT in the ~/.bucket file.")

      { "username" => username, "password" => password }
    end
  end
end