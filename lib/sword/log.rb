module Sword
  class Log < ActiveSupport::Logger

    attr_reader :start_time, :datetime_format, :output_level

    def initialize(*args)
      @start_time = Time.now
      @datetime_format = '%Y-%m-%d %H:%M:%S'
      @output_level = args[0]

      # reset the first argument to the log file for the super call
      args[0] = 'log/sword.log'
      super

      self.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime.strftime(@datetime_format)} #{severity} #{msg}\n"
      end

      self.info "Packager started"
    end

    def close
      end_time = Time.now
      duration = (end_time - @start_time) / 1.minute
      self.info "Duration: #{duration}"
      self.info "Packager ended"
      super
    end

  end
end
