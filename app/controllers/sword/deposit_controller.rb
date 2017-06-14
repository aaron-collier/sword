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

      filename = request.headers["Content-disposition"].split('=').last
      unless filename.nil?
        File.open(File.join(Sword.config.upload_path,filename), "wb") do |f|
          f.write(request.raw_post)
        end

        @sword_package = Package.new(filename: filename)

        Sword.config.logger.info "#{@sword_package.filename} successfully uploaded"

        Sword.config.logger.info "Creating item with id: #{@sword_package.work.id}"

        @work = @sword_package.work
        # @work_url = app.hyrax_work_path(@work)

        render "index.xml.erb"
      end
    end
  end
end
