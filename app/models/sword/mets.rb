module Sword
  class Mets
    include ActiveModel::Model

    attr_accessor :xml
    attr_reader :metadata
    attr_reader :bitstreams

    def initialize(args)
      @xml = args[:xml]
      @metadata = Hash.new {|h,k| h[k]=[]}
      @bitstreams = Array.new()
      load_metadata
      load_bitstreams
    end

    def load_metadata
      Sword.config.ingest['fields'].each do |field|
        metadata_holder = xml.xpath("#{Sword.config.ingest['xpath_prefix']}#{field[1]['xpath']}",Sword.config.ingest['namespace'])
        metadata_holder.each do |metadata_string|
          metadata[field[0]] << metadata_string.inner_html
        end
      end
    end

    def load_bitstreams
      bitstream_metadata = xml.xpath(Sword.config.ingest['bitstreams']['xpath'],Sword.config.ingest['namespace'])
      bitstream_metadata.each do |bitstream|
        bitstreams << bitstream['xlink:href']
      end
    end
  end
end
