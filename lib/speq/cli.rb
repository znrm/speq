require 'find'
require 'colorize'
require 'speq/report'

module Speq
  # CLI for running Speq
  module CLI
    def self.find_files(file_prefixes)
      file_prefixes << '*' if file_prefixes.empty?

      Dir.glob("#{Dir.pwd}/**/{#{file_prefixes.join(',')}}_speq.rb")
    end

    def self.print_report(tests)
      Speq::Report.new(tests).inspect
    end
  end
end
