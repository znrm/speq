require 'find'

# Provides a CLI for running Speq
module Speq
  class CLI
    attr_accessor :groups

    def initialize(cli_args)
      @files = find_files(cli_args)
      @groups = []
    end

    def find_files(file_prefixes)
      file_prefixes << '*' if file_prefixes.empty?

      Dir.glob("#{Dir.pwd}/**/{#{file_prefixes.join(',')}}_speq.rb")
    end

    def does(*args, **kw_args, &block)
      groups << [args, kw_args, block]
    end

    def run
      @files.each { |file| instance_eval(File.read(file)) }
    end
  end
end
