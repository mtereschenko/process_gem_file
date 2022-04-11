module Filter
  class Filter
    def self.clear_comments(reader)
      raise "Reader should be instance of Reader::Read" unless reader.is_a? Reader::Read

      content = reader.content
      reader.set_content(content.gsub(/(?<=\s)#.*\n/, "\n"))
    end

    def self.clear_blank_lines(reader)
      raise "Reader should be instance of Reader::Read" unless reader.is_a? Reader::Read

      content = reader.content
      reader.set_content(content.gsub(/(?:^\s*?\n)/, ""))
    end
  end
end
