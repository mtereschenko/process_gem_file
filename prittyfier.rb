# frozen_string_literal: true

require './autoloader'

def draw_help
  Initializer::App.available_arguments.each do |key, value|
    puts "#{key.to_s.ljust(30)}#{value}"
  end
  abort
end

begin
  app = Initializer::App.new
  draw_help if app.params.key?(:h) || app.params.key?(:help)

  source_file = app.params[:f] || app.params[:file]
  reader = Reader::Read.new(source_file)

  Filter::Filter.clear_comments(reader) if app.params.key?(:nc) || app.params.key?(:nocomments)
  Filter::Filter.clear_blank_lines(reader) if app.params.key?(:nbl) || app.params.key?(:noblanklines)
  reader.sort_gems if app.params.key?(:s) || app.params.key?(:sort)
  output_file = app.params[:o] || app.params[:output]
  dry_run = app.params.key?(:dryrun)
  app = Writer::Write.new(reader, dry_run)
  app.output_path = (output_file) if output_file
  app.write
rescue StandardError => e
  puts e
end
