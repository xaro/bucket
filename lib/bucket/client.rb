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
  end
end