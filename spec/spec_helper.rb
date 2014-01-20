require "minitest/autorun"
require "minitest/pride"

require 'rr'

require_relative "../lib/bucket"
require_relative "../lib/bucket/cli"

# Thor complains when a task does not have a description, we
# need to silence it when mocking commands
# https://github.com/jondot/logbook/blob/master/spec/spec_helper.rb
require 'thor'
class Thor
  class << self
    def create_command(meth) #:nodoc:
      if @usage && @desc
        base_class = @hide ? Thor::HiddenTask : Thor::Task
        tasks[meth] = base_class.new(meth, @desc, @long_desc, @usage, method_options)
        @usage, @desc, @long_desc, @method_options, @hide = nil
        true
      elsif self.all_tasks[meth] || meth == "method_missing"
        true
      else
        false
      end
    end
  end
end