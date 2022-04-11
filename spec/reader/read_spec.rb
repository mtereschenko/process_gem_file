require './autoloader.rb'

RSpec.describe Reader::Read do

  before do
    @source_file_name = "#{__dir__}/../Gemfile"
  end

  describe ".new" do
    context 'initialize new instance on Reader::Read' do
      it "will prepare reader process source file further" do
        reader = Reader::Read.new(@source_file_name)

        expect(reader).to be_instance_of(Reader::Read)
      end

      it "should be raised an error of file not specified" do
        some_unknown_file = 'file_not_exists'
        exception_message = 'File not found'

        expect { Reader::Read.new(some_unknown_file) }
          .to raise_error(SystemExit).with_message(exception_message)
      end

      it "should be raised an error of provided file is directory" do
        some_unknown_file = __dir__
        exception_message = 'File not specified'

        expect { Reader::Read.new(some_unknown_file) }
          .to raise_error(SystemExit).with_message(exception_message)
      end
    end
  end

  describe ".set_content" do
    context 'should replace current content with user content' do
      it "and set it in content field" do
        content = 'content'
        reader = Reader::Read.new(@source_file_name)
        reader.set_content(content)

        expect(reader.content).to eq(content)
      end

      it "and raise an error of not valid content" do
        exception_message = 'Content should be string'
        content = 123
        reader = Reader::Read.new(@source_file_name)
        expect { reader.set_content(content) }
          .to raise_error(RuntimeError).with_message(exception_message)
      end
    end
  end

  describe ".parse_groups" do
    context 'should parse groups of gems of provided Gemfile' do
      it "and return hash with parsed groups" do
        expected_hash = {
          "default" => ["puma", "rails", "sqlite3", "tzinfo-data"],
          ":development"=>["bullet", "web-console", "listen", "rack-mini-profiler", "faker", "spring"],
          ":development, :test" => ["byebug", "rspec-rails"],
          ":test" => ["capybara", "selenium-webdriver"]
        }
        reader = Reader::Read.new(@source_file_name)
        parsed_groups = reader.parse_groups

        expect(parsed_groups).to eq(expected_hash)
      end
    end
  end
end
