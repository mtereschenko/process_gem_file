module Reader
  class Read
    attr_reader :file_name, :content, :groups

    def initialize(file_name)
      Validator::Validate.check_if_file_exists(file_name)
      Validator::Validate.check_if_file(file_name)
      Validator::Validate.check_if_file_can_be_readed(file_name)
      @content = File.read(file_name)
    end

    def set_content(content)
      raise "Content should be string" unless content.is_a? String
      @content = content
    end

    def parse_groups
      prepared_content = prepare_content
      groups = {
        'default' => []
      }

      groups_matches = prepared_content.scan(/(?:group ).*?(?: end)/)
      groups_matches.each do |group|
        prepared_content = prepared_content.gsub(group.to_s, '')
        group_name = group.match(/(?<=group ).+?(?= do)/).to_s
        groups[group_name] ||= []
        groups[group_name].concat get_gems(group)
        groups[group_name] = groups[group_name]
      end
      groups['default'] = get_gems(prepared_content)
      @groups = groups
    end

    def sort_gems
      prepared_content = prepare_content
      new_content = ''
      new_content += prepared_content.match(/^.*?(?=gem )/).to_s.gsub(' EOL ', "\n") + "\n"

      parse_groups
      groups.each do |group_name, gems|
        new_content += "\ngroup #{group_name} do\n" unless group_name == 'default'
        gems.each do |gem|
          regex = '((?:^\s*?#.*\n){0,}?+^\s*?(?:gem\s[\'"]' + gem + '[\'"].*?))\n'
          new_content += content.match(/#{regex}/).to_s
        end
        new_content += "end\n" unless group_name == 'default'
      end

      set_content(new_content)
    end

    private

    def prepare_content
      content.gsub("\n", ' EOL ')
    end

    def get_gems(content)
      result = []
      content.gsub(' EOL ', "\n").scan(/^(?:^\s*?gem).+(?<=gem ['"]).+?(?=['"])/).each do |line|
        gem_name = line.to_s.gsub(/\s.*gem\s.*['"]/, '').to_s.gsub(/gem\s.*['"]/, '')
        result.append(gem_name)
      end
      result.sort
    end

  end
end