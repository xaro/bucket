module Bucket
  class Client
    GIT_URL = "git@bitbucket.org"

    def initialize(credentials)
      @connection = BitBucket.new basic_auth: "#{credentials["username"]}:#{credentials["password"]}"
      @user = credentials["username"]
    end

    def repos_list
      @connection.repos.list
    end

    def repo_url(name)
      split_name = name.split "/"

      if split_name.size == 1
        user = @user
        slug = split_name[0]
      else
        user = split_name[0]
        slug = split_name[1]
      end
      
      "#{GIT_URL}:#{user}/#{slug}.git"
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