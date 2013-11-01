module Bucket
  class Client
    GIT_URL = "git@bitbucket.org"

    def initialize(credentials)
      @connection = BitBucket.new basic_auth: "#{credentials["username"]}:#{credentials["password"]}"
    end

    def repos_list
      @connection.repos.list
    end

    def repo_url(user, name)
      "#{GIT_URL}:#{user}/#{name}.git"
    end

    def repo_full_name(repo)
      "#{repo[:owner]}/#{repo[:slug]}"
    end

    # Returns the created repository scm url
    def create_repo(name, options={})
      options = options.merge(is_private: !options[:public])

      @connection.repos.create(options.merge(name: name))
    end

  end
end