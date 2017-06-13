module Sword
  class Package
    include ActiveModel::Model

    attr_accessor :filename
    attr_reader :files, :path, :bitstreams, :work

    def initialize(args)
      @filename = args[:filename]
      @bitstreams = Array.new()

      unzip
      mets
      upload_bitstreams
      create_work

    end

    def files
      @files ||= []
    end

    private

    def mets
      @mets ||= Mets.new(xml: Nokogiri::XML(File.open(File.join(@path,'mets.xml'))))
    end

    def unzip

      begin
        @path = initialize_directory(File.join(Sword.config.working_path, File.basename(@filename, ".zip")))

        Zip::File.open(File.join(Sword.config.upload_path,@filename)) do |file_to_extract|
          file_to_extract.each do |compressed_file|
            file_to_extract.extract(compressed_file.name,File.join(path,compressed_file.name))
            files << compressed_file.name
          end
        end
      rescue => error_msg
        Sword.config.logger.error error_msg
      end
    end

    def upload_bitstreams
      mets.bitstreams.each do |bitstream|
        hyrax_file = Hyrax::UploadedFile.create(file: File.open(File.join(path,bitstream)))
        hyrax_file.save
        bitstreams.push(hyrax_file)
      end
    end

    def initialize_directory(dir)
      Dir.mkdir dir unless Dir.exist?(dir)
      return dir
    end

    def create_work
      mets.metadata[:id] = ActiveFedora::Noid::Service.new.mint
      mets.metadata[:visibility] = "open"
      @work = Work.new(mets.metadata)
      work.apply_depositor_metadata("acollier@calstate.edu")
      work.save

      AttachFilesToWorkJob.perform_now(work,bitstreams)
    end

  end
end
