require "mongoid"

Mongoid.load!("#{Dir.pwd}/config/mongoid.yml")

module Mongoid
  module Document
    def serializable_hash(options = nil)
      h = super(options)
      h.delete('_id') if h.has_key?('_id')
      h
    end
  end
end
