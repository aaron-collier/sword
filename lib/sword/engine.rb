module Sword
  class Engine < ::Rails::Engine
    isolate_namespace Sword

    def logger
      @logger ||= Sword::Log.new
    end
  end
end
