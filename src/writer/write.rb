# frozen_string_literal: true

require 'fileutils'

module Writer
  # Class allows you to write content of class Write to file
  class Write
    def initialize(reader, dry_run)
      raise 'Reader should be instance of Reader::Read' unless reader.is_a? Reader::Read

      @reader = reader
      @dry_run = dry_run || false
      @output_path = reader.file_name
    end

    def write
      if dry_run
        puts reader.content
      else
        mkdir_if_needed
        process_existed_file if File.exist?(output_path)
        put_content_to_file
      end
    end

    def process_existed_file
      option = ''
      while option != 'Y' && option != 'N'
        puts 'File already exists. Are you sure you want to override it? (Y/N)'
        option = $stdin.gets.chomp.to_s.strip
      end

      raise 'Aborted by user' unless option == 'Y'
    end

    def mkdir_if_needed
      dir = output_path.gsub(File.basename(output_path), '')
      FileUtils.mkdir_p(dir) unless File.exist?(dir)
    end

    attr_accessor :output_path

    private

    attr_reader :reader, :dry_run

    def put_content_to_file
      File.open(output_path, 'w') { |f| f.write('') }

      File.open(output_path, 'a') do |file|
        reader.content.split("\n").each do |line|
          file.write("#{line.rstrip}\n")
        end
      end
    end
  end
end
