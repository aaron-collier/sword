require_dependency "sword/application_controller"

module Sword
  class DepositController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def index
      puts request.body.read
    end

    def create
      render :text => "#{request.params}"
      File.open("/tmp/upload.zip", "wb") do |f|
        f.write(request.raw_post)
      end
    end
  end
end
