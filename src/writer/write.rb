require 'fileutils'

module Writer
  class Write

    def initialize(reader, dry_run)
      raise "Reader should be instance of Reader::Read" unless reader.is_a? Reader::Read

      @reader = reader
      @dry_run = dry_run || false
      @output_path = reader.file_name
    end

    def write
      if dry_run
        puts reader.content
      else
        mkdir_if_needed
        if File.exists?(output_path)
          puts Validator::Validate.check_if_file_exists(output_path)
          raise "Aborted by user" unless process_existed_file
        end

        File.open(output_path, 'w') { |f| f.write('') }
        File.open(output_path, 'a') { |f| f.write(reader.content) }
      end

    end

    def process_existed_file
      option = ''
      while option != 'Y' && option != 'N' do
        puts "File already exists. Are you sure you want to override it? (Y/N)"
        option = STDIN.gets.chomp.to_s.strip
      end

      option == 'Y'
    end

    def mkdir_if_needed
      dir = output_path.gsub(File.basename(output_path), '')
      FileUtils.mkdir_p(dir) unless File.exists?(dir)
    end

    def set_output_path(output_path)
      @output_path = output_path
    end

    private

    attr_reader :output_path, :reader, :dry_run

  end
end