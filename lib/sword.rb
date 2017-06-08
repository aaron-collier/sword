require "sword/engine"
require "sword/log"

module Sword
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Configuration
  end

  # @api public
  #
  # Exposes the Packager configuration
  #
  # @yield [Packager::Configuration] if a block is passed
  # @return [Packager::Configuration]
  # @see Sword::Configuration for configuration options
  def self.config(&block)
    @config ||= Sword::Configuration.new

    yield @config if block

    @config
  end
end
