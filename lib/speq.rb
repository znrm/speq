require 'speq/version'
require 'speq/test'
require 'speq/match'
require 'speq/fake'
require 'speq/cli'

module Speq
  module_function

  def does(*args, **kw_args, &block)
    [args, kw_args, block]
  end
end
