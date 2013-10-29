module Bucket
  class Client
    def initialize(oauth)
      @key = oauth[:key]
      @secret = oauth[:secret]
    end
  end
end