require_dependency "sword/application_controller"

module Sword
  class ServicedocumentController < ApplicationController

    attr_reader :user

    before_filter :http_authenticate

    # before_action :authenticate_user!

    def index
      admin_sets_for_user
      render "index.xml.erb"
    end

    protected

    def http_authenticate
      authenticate_or_request_with_http_basic do |username, password|
        @user ||= User.find_by_user_key(username)
        !user.nil? && user.valid_password?(password)
      end
      warden.custom_failure! if performed?
    end

    def admin_sets_for_user
      @admin_sets_for_user ||= @user.ability.admin_set_ids_for_deposit
    end

  end
end
