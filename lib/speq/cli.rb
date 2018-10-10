require 'find'
require 'colorize'
require 'speq/test'

# Provides a CLI for running Speq
module Speq
  class CLI
    attr_accessor :tests

    def initialize(cli_args)
      @files = find_files(cli_args)
      @tests = []
    end

    def find_files(file_prefixes)
      file_prefixes << '*' if file_prefixes.empty?

      Dir.glob("#{Dir.pwd}/**/{#{file_prefixes.join(',')}}_speq.rb")
    end

    def does(subject, &block)
      tests << Test.new(subject, self, &block)
    end

    def run
      @files.each { |file| instance_eval(File.read(file), file) }
      @tests.each(&:report)
      @tests.all?(&:passed?)
    end
  end
end
