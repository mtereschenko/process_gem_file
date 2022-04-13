# frozen_string_literal: true

def preload_app
  files = Dir['src/**/*.rb'].reject do |file_name|
    File.directory?(file_name) || File.basename(__FILE__) == File.basename(file_name)
  end

  files.each do |file|
    require_relative "./#{file}"
  end
end

preload_app
