require_dependency "sword/application_controller"

module Sword
  class DepositController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def index
      puts response.headers
    end

    def create
      # render :text => request.headers["Content-disposition"].split('=').last

      # TODO: This response is temporary, the 200 response should only come
      # after the item has been successfully ingested into the IR
      render :status => 200, :text => "file uploaded successfully"

      filename = request.headers["Content-disposition"].split('=').last
      unless filename.nil?
        File.open(File.join(Sword.config.upload_path,filename), "wb") do |f|
          f.write(request.raw_post)
        end
        p = Package.new(filename: filename)
        Sword.config.logger.info "#{p.filename} successfully uploaded"
        p.unzip
        Sword.config.logger.info "Mets file at #{p.path}"

        mets_data = Mets.new(xml: Nokogiri::XML(File.open(File.join(p.path,'mets.xml'))))

        Sword.config.ingest['fields'].each do |field|
          Sword.config.logger.info "Looking for: #{field[0]}"
          metadata = mets_data.xml.xpath("#{Sword.config.ingest['xpath_prefix']}#{field[1]['xpath']}",Sword.config.ingest['namespace'])
          metadata.each do |metadata_string|
            Sword.config.logger.info "Metadata found: #{metadata_string.inner_html}"
            mets_data.metadata[field[0]] << metadata_string.inner_html
          end
        end

        mets_data.metadata[:id] = ActiveFedora::Noid::Service.new.mint
        mets_data.metadata[:visibility] = "open"

        Sword.config.logger.info mets_data.metadata

        w = Work.new(mets_data.metadata)
        w.apply_depositor_metadata("acollier@calstate.edu")
        w.save

        uploaded_files = Array.new()
        bitstreams = mets_data.xml.xpath(Sword.config.ingest['bitstreams']['xpath'],Sword.config.ingest['namespace'])
        bitstreams.each do |bitstream|
          Sword.config.logger.info File.join(p.path,bitstream['xlink:href'])
          hyrax_file = Hyrax::UploadedFile.create(file: File.open(File.join(p.path,bitstream['xlink:href'])))
          hyrax_file.save
          uploaded_files.push(hyrax_file)
        end

        AttachFilesToWorkJob.perform_now(w,uploaded_files)

      end
    end
  end
end
