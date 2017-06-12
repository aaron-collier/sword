module Sword
  class Package
    include ActiveModel::Model

    attr_accessor :filename
    attr_reader :files
    attr_reader :path

    def files
      @files ||= []
    end

    def unzip
      Sword.config.logger.info "Unzipping #{@filename}"

      begin
        @path = initialize_directory(File.join(Sword.config.working_path, File.basename(@filename, ".zip")))

        Zip::File.open(File.join(Sword.config.upload_path,@filename)) do |file_to_extract|
          file_to_extract.each do |compressed_file|
            Sword.config.logger.info " -- Unpacking file #{compressed_file.name}"
            file_to_extract.extract(compressed_file.name,File.join(path,compressed_file.name))
            files << compressed_file.name
          end
        end
      rescue => error_msg
        Sword.config.logger.error error_msg
      end
    end

    private

    def initialize_directory(dir)
      Dir.mkdir dir unless Dir.exist?(dir)
      return dir
    end

  end
end
