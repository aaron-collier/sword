module Sword
  class Configuration

    attr_writer :logger
    def logger
      @logger ||= Sword::Log.new
    end

  end
end
