module FactoryBot
  class << self
    # An Array of strings specifying locations that should be searched for
    # factory definitions. By default, factory_bot will attempt to require
    # "factories", "test/factories" and "spec/factories". Only the first
    # existing file will be loaded.
    attr_accessor :definition_file_paths
  end

  self.definition_file_paths = %w[factories test/factories spec/factories]

  def self.find_definitions
    absolute_definition_file_paths = definition_file_paths.map { |path| File.expand_path(path) }

    absolute_definition_file_paths.uniq.each do |path|
      load_file_or_directory(path)
    end
  end

  def self.load_file_or_directory(path)
    load("#{path}.rb") if File.exist?("#{path}.rb")

    load path if File.file? path

    if File.directory? path
      Dir[File.join(path, "**", "*.rb")].sort.each do |file|
        load file
      end
    end
  end
end
