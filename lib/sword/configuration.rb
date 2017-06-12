module Sword
  class Configuration

    attr_writer :logger
    def logger
      @logger ||= Sword::Log.new
    end

    attr_writer :upload_path
    def upload_path
      @upload_path ||= "/tmp"
    end

    attr_writer :working_path
    def working_path
      @working_path ||= "/tmp/sword"
    end

    attr_writer :ingest
    def ingest
      @ingest ||= Rails.application.config_for(:sword_ingest)
    end
  end
end
