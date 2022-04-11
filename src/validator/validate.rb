# frozen_string_literal: true

module Validator
  # Class need to handle any type of validations in app
  class Validate
    def self.check_if_file_exists(file_name)
      abort('File not found') unless File.exist?(file_name)
    end

    def self.check_if_file(file_name)
      abort('File not specified') unless File.file?(file_name)
    end

    def self.check_if_file_can_be_readed(file_name)
      abort('File not specified') unless File.readable?(file_name)
    end
  end
end
