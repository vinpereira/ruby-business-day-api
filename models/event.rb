require 'mongoid'

class Event
  include Mongoid::Document

  embedded_in :holiday

  validates_presence_of :date, :name, :type_code

  field :date, type: Date
  field :name, type: String
  field :type, type: String
  field :type_code, type: Integer
end
