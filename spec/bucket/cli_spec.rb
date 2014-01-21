require 'spec_helper'
require 'fakefs/safe'

describe Bucket::CLI do
  subject { Bucket::CLI.new }

  # Use a fake filesystem and clear it after each test
  before do
    mock_credentials
    FakeFS.activate!

    # Create a fake user's home (in reality this folder will exist)
    FileUtils.mkdir_p(Dir.home)
  end
  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
  end

  it "saves the user and password to the configuration file" do
    # The setup is run when initializing the CLI
    out = capture_io { subject }

    config = YAML.load_file("#{Dir.home}/.bucket")
    config.must_equal({ "username" => "user", "password" => "password" })
  end

  it "replaces the user and password when calling setup" do
    # Run the setup when initializing (and ignore output)
    capture_io { subject }

    # Run the setup again with other credentials
    mock_credentials("other_user", "other_password")
    capture_io { subject.setup }

    config = YAML.load_file("#{Dir.home}/.bucket")
    config.must_equal({ "username" => "other_user", "password" => "other_password" })
  end

  it "displays a list of the user's repositories" do
    any_instance_of(Bucket::Client) do |client|
      mock(client).repos_list do
        [
          { owner: "user", slug: "repository" },
          { owner: "other_user", slug: "other_repository" }
        ]
      end
    end

    out = capture_io { subject.repos }.join('')
    out.must_match(/user\/repository/)
    out.must_match(/other_user\/other_repository/)
  end
end

def mock_credentials(username = "user", password = "password")
  any_instance_of(Bucket::CLI) do |cli|
    mock(cli).ask("Username:") { username }
    mock(cli).ask("Password:", anything) { password }
  end
end