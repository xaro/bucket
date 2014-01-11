require "thor"
require "io/console"
require "yaml"
require_relative "../bucket"

module Bucket
  class CLI < Thor
    include Thor::Actions

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
      print run("git clone #{@client.repo_url(name)}", capture: true, verbose: false)
    end

    desc "init DIRECTORY", "Create a new repository locally and on BitBucket."
    option :name, desc: "The name of the repository."
    option :description, desc: "A description for the repository."
    option :public, desc: "Sets if the repository is public or private.", type: :boolean, default: false
    def init(directory)
      expanded_dir = File.expand_path(directory)
      print run("git init #{expanded_dir}", capture: true, verbose: false)

      repo = @client.create_repo(options[:name] || File.basename(expanded_dir), options)
      repo_url = @client.repo_url("#{repo[:owner]}/#{repo[:slug]}")
      print run("git remote add origin #{repo_url}", capture: true, verbose: false)

      say("Repository #{@client.repo_full_name(repo)} created.")
    end

    private
    def load_config
      YAML.load_file("#{Dir.home}/.bucket")
    rescue
      generate_config
    end

    def generate_config
      save_config(ask_credentials)
    end

    def save_config(credentials)
      File.open "#{Dir.home}/.bucket", 'w', 0600 do |f|
        YAML.dump(credentials , f)
      end

      credentials
    end

    def ask_credentials
      username = @shell.ask("Username:")

      # We ask the password this way to avoid echoing it
      @shell.say("Password: ")
      password = $stdin.noecho(&:gets).strip
      @shell.say("")

      { username: username, password: password }
    end
  end
end