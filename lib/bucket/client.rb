module Bucket
  class Client
    GIT_URL = "git@bitbucket.org"

    def initialize(credentials)
      @connection = BitBucket.new(basic_auth: "#{credentials["username"]}:#{credentials["password"]}")
      @user = credentials["username"]
    end

    def repos_list
      @connection.repos.list
    end

    # Full url for the given repository
    # The repository name must be of the style [USER]/[REPOSITORY] or
    # [REPOSITORY] in which case the name of the current user
    # will be used as owner
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

    # A repository full name is of the style of [USER]/[REPOSITORY]
    def repo_full_name(repo)
      "#{repo[:owner]}/#{repo[:slug]}"
    end

    def init(directory, options = {})
      expanded_dir = File.expand_path(directory)
      repository = Git::Base.init(expanded_dir)

      # If there is not a name specified, use the name of the target directory
      name = options[:name] || File.basename(expanded_dir)

      # Create the BitBucket repository and add it to the local remotes
      remote_repository = create_repo(name, options)
      remote_url = repo_url("#{remote_repository[:owner]}/#{remote_repository[:slug]}")
      repository.add_remote("BitBucket", remote_url)

      repository
    end

    # Returns the created repository scm url
    def create_repo(name, options={})
      options = options.merge(is_private: !options[:public])

      @connection.repos.create(options.merge(name: name))
    end
  end
end