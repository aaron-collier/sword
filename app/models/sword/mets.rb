module Sword
  class Mets
    include ActiveModel::Model

    attr_accessor :xml
    attr_reader :metadata

    def initialize(args)
      @xml = args[:xml]
      @metadata = Hash.new {|h,k| h[k]=[]}
      load_metadata
    end

    def load_metadata
      Sword.config.ingest['fields'].each do |field|
        Sword.config.logger.info "Looking for: #{field[0]}"
        metadata_holder = @xml.xpath("#{Sword.config.ingest['xpath_prefix']}#{field[1]['xpath']}",Sword.config.ingest['namespace'])
        metadata_holder.each do |metadata_string|
          Sword.config.logger.info "Metadata found: #{metadata_string.inner_html}"
          @metadata[field[0]] << metadata_string.inner_html
        end
      end
    end
  end
end
