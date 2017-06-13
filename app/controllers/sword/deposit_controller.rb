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

        Sword.config.logger.info "Creating item with id: #{p.work.id}"

      end
    end
  end
end
