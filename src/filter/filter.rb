# frozen_string_literal: true

module Filter
  # Helper class that allow to filter Gemfile content in different ways
  class Filter
    def self.clear_comments(reader)
      raise 'Reader should be instance of Reader::Read' unless reader.is_a? Reader::Read

      reader.content = reader.content.gsub(/(?<=\s)#.*\n/, "\n").gsub(/^#.*\n/, "\n")
    end

    def self.clear_blank_lines(reader)
      raise 'Reader should be instance of Reader::Read' unless reader.is_a? Reader::Read

      content = reader.content
      reader.content = content.gsub(/(?:^\s*?\n)/, '')
    end
  end
end
