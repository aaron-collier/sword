require_dependency "sword/application_controller"

module Sword
  class DepositController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def index
      puts response.headers
    end

    def create
      # render :text => request.headers["Content-disposition"].split('=').last
      render :status => 200, :text => "file uploaded successfully"
      filename = request.headers["Content-disposition"].split('=').last
      File.open("/tmp/#{filename}", "wb") do |f|
        f.write(request.raw_post)
      end
    end
  end
end
