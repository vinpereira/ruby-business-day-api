require "mongoid"
require "#{Dir.pwd}/models/event"

class Holiday
  include Mongoid::Document

  store_in collection: "holidays"

  validates_presence_of :year, :state, :city

  field :year, type: String
  field :state, type: String
  field :city, type: String
  field :country, type: String

  embeds_many :events
end
