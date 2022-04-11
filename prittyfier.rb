#!ruby
require './autoloader.rb'

def draw_help
  Initializer::App.available_arguments.each do |key, value|
    puts "#{key.to_s.ljust(30)}#{value}"
  end
  abort
end

begin
  app = Initializer::App.new
  if app.params.key?(:h) || app.params.key?(:help)
    draw_help
  end

  source_file = app.params[:f] || app.params[:file]
  reader = Reader::Read.new(source_file)
  if app.params.key?(:nc) || app.params.key?(:nocomments)
    Filter::Filter.clear_comments(reader)
  end
  if app.params.key?(:nbl) || app.params.key?(:noblanklines)
    Filter::Filter.clear_blank_lines(reader)
  end
  if app.params.key?(:s) || app.params.key?(:sort)
    reader.sort_gems
  end

  output_file = app.params[:o] || app.params[:output]
  dry_run = app.params.key?(:dryrun)
  app = Writer::Write.new(reader, dry_run)
  app.set_output_path(output_file) if output_file
  app.write

rescue StandardError => e
  puts e
end
