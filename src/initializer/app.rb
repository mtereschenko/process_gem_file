# frozen_string_literal: true

module Initializer
  # Generally class have to initialize app parameters and parameter values
  class App
    attr_reader :params

    def initialize
      initialize_arguments
    end

    def self.available_arguments
      {
        '-h': 'Help',
        '--help': 'Help',
        '-f': 'Set source file',
        '--file': 'Set source file',
        '-o': 'Set output file',
        '--output': 'Set output file',
        '--dry-run': 'Run app without any changes to source or output file',
        '-nc': 'Clear source of comments',
        '--no-comments': 'Clear source of comments',
        '-nbl': 'Clear source of blank lines',
        '--no-blank-lines': 'Clear source of blank lines',
        '-s': 'Sort packages ABS',
        '--sort': 'Sort packages ABS'
      }
    end

    private

    def initialize_arguments
      @params = {}
      prepare_params
    end

    def prepare_params
      ARGV.each do |argument|
        parsed_argument = parse_argument(argument)
        raise "Unknown argument #{parsed_argument[:key]}" unless self.class.available_arguments[parsed_argument[:key]]

        @params[parsed_argument[:key].to_s.gsub('-', '').to_sym] = parsed_argument[:value]
      end
    end

    def parse_argument(argument)
      result = {
        key: nil,
        value: nil
      }
      separated = argument.split('=')
      result[:key] = separated[0].to_sym
      result[:value] ||= separated[1]
      result
    end
  end
end
