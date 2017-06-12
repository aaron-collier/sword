module Sword
  class Mets
    include ActiveModel::Model

    attr_accessor :xml
    attr_reader :metadata

    def metadata
      @metadata ||= Hash.new {|h,k| h[k]=[]}
    end

  end
end
