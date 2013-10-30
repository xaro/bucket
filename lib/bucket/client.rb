module Bucket
  class Client
    def initialize(credentials)
      @connection = BitBucket.new basic_auth: "#{credentials[:username]}:#{credentials[:password]}"
    end
  end
end