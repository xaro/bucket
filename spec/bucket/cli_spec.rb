require 'spec_helper'
require 'fakefs/safe'

describe Bucket::CLI do
  subject { Bucket::CLI.new }

  # Use a fake filesystem and clear it after each test
  before do
   FakeFS.activate!

   # Create a fake user's home (in reality this folder will exist)
   FileUtils.mkdir_p(Dir.home)
  end
  after do
   FakeFS.deactivate!
   FakeFS::FileSystem.clear
  end

  it "saves the user and password to the configuration file" do
    mock_credentials

    # The setup is run when initializing the CLI
    out = capture_io { subject }

    config = YAML.load_file("#{Dir.home}/.bucket")
    config.must_equal({ "username" => "user", "password" => "password" })
  end

  it "replaces the user and password when calling setup" do
    mock_credentials

    # Run the setup when initializing
    capture_io { subject }

    # Run the setup again with other credentials
    mock_credentials("other_user", "other_password")
    capture_io { subject.setup }

    config = YAML.load_file("#{Dir.home}/.bucket")
    config.must_equal({ "username" => "other_user", "password" => "other_password" })
  end
end

def mock_credentials(username = "user", password = "password")
  any_instance_of(Bucket::CLI) do |cli|
    mock(cli).ask("Username:") { username }
    mock(cli).ask("Password:", anything) { password }
  end
end