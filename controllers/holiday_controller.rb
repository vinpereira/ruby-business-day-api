# encoding: UTF-8
require 'date'
require 'json'
require 'sinatra'
require 'yaml'

require_relative "#{Dir.pwd}/config/mongoid"
require_relative "#{Dir.pwd}/models/holiday"

class HolidayController
  URI = URI('http://www.calendario.com.br/api/api_feriados.php')

  OPTIONAL_DAY_OFF_TYPE = 4       # Code 4 is for 'Ponto Facultativo' -- a optional holiday (like Carnival)
  CONVENTIONAL_HOLIDAY_TYPE = 9   # Code 9 is for 'Dia Convencional' -- a festive day that may or may not be a holiday (depends of each city)

  def get(params = {})
    holiday = Holiday.where(params)

    return save(params) unless holiday.exists?

    holiday.first
  end

  def range(params = {})
    holiday = get(@holiday_params)

    result = []

    holiday.events.each do |event|
      result.push(JSON.parse(event.to_json)) if event.date.between?(params[:start], params[:end])
    end

    result
  end

  def holiday?(params = {})
    holiday = get(@holiday_params)

    result = holiday.events.detect do |event|
      event.date == params[:date] && event.type_code != OPTIONAL_DAY_OFF_TYPE && event.type_code != CONVENTIONAL_HOLIDAY_TYPE
    end

    ! result.nil?
  end

  private
  def save(params = {})
    response = get_response(params)

    holiday = Holiday.new

    holiday.year = params[:year]
    holiday.state = params[:state]
    holiday.city = params[:city]
    holiday.country = response["events"]["location"]["country"]

    holiday.save!

    response["events"]["event"].each do |event|
      holiday.events.create(
        date: Date.strptime(event["date"], "%d/%m/%Y"),
        name: event["name"],
        type: event["type"],
        type_code: event["type_code"]
      )
    end

    holiday
  end

  def get_response(options = { year: Time.now.year, state: '', city: '' })
    query = build_query(options)

    response = HTTParty.get(URI, :query => query)
    data = response.parsed_response

    Hash.from_xml(data)
  end

  def build_query(options = { year: '', state: '', city: ''})
    config = YAML.load_file("#{Dir.pwd}/config/holiday.yml")

    query = {
      "ano" => options[:year].to_s,
      "estado" => options[:state].to_s,
      "cidade" => options[:city].to_s,
      "token" => config["token"]
    }

    query
  end
end
