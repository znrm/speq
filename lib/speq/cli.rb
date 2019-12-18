# frozen_string_literal: true

require 'find'
require 'date'
require 'pry'

module Speq
  # Includes useful methods for running Speq from a CLI
  module CLI
    def self.run(cli_args)
      run_tests(find_files(cli_args))
    end

    def self.run_and_report(cli_args)
      print_report(run(cli_args))
    end

    def self.run_tests(paths)
      collection = Test.new(DateTime.now)

      paths.each do |file|
        collection.speq(file_name_to_test_description(file)) do
          instance_eval(File.read(file), file)
        end
      end

      collection
    end

    def self.file_name_to_test_description(path)
      path
        .split('/').last
        .delete_suffix('_speq.rb')
        .split('_')
        .map(&:capitalize)
        .join(' ')
    end

    def self.find_files(cli_args)
      prefixes = cli_args.empty? ? ['*'] : cli_args
      glob_pattern = "#{Dir.pwd}/**/{#{prefixes.join(',')}}_speq.rb"
      Dir.glob(glob_pattern)
    end

    def self.print_report(tests)
      puts tests, '', tests.report
    end
  end
end
