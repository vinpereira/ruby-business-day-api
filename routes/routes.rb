# encoding: UTF-8
require 'active_support'
require 'active_support/core_ext'
require 'date'
require 'httparty'
require 'json'
require 'sinatra'

require_relative "#{Dir.pwd}/config/mongoid"
require_relative "#{Dir.pwd}/models/holiday"

class MyAppRoutes < Sinatra::Base
  URI = URI('http://www.calendario.com.br/api/api_feriados.php')
  TOKEN = 'dnAudmluaWNpdXMucGVyZWlyYUBnbWFpbC5jb20maGFzaD0xNTMxMTU2MTc='
  OPTIONAL_DAY_OFF_TYPE = 4       # Code 4 is for 'Ponto Facultativo' -- a optional holiday (like Carnival)
  CONVENTIONAL_HOLIDAY_TYPE = 9   # Code 9 is for 'Dia Convencional' -- a festive day that may or may not be a holiday (depends of each city)

  helpers do
    def normalize(str)
      str.force_encoding("UTF-8").unicode_normalize(:nfkd).encode('ASCII-8BIT', replace: '')
    end
  end

  before do
    content_type :json
  end

  get '/:state/:city/holiday/:date' do
    date = Date.strptime("#{ params[:date] }", "%Y-%m-%d")
    hp = { city: normalize(params[:city]).upcase, state: params[:state].upcase, year: date.year }

    get_holiday(hp)

    holiday = Holiday.where(
      "year" => hp[:year],
      "city" => hp[:city],
      "state" => hp[:state],
      "events.date" => date
    )

    halt 200, JSON.pretty_generate({ holiday: holiday.exists? })
  end

  get '/:year/:state/:city/range/:start_date/:end_date' do
    start_date = Date.strptime("#{ params[:year] }-#{ params[:start_date] }", "%Y-%m-%d")
    end_date = Date.strptime("#{ params[:year] }-#{ params[:end_date] }", "%Y-%m-%d")
    hp = { city: normalize(params[:city]).upcase, state: params[:state].upcase, year: params[:year] }

    holiday = get_holiday(hp)

    result = []

    holiday.events.each do |event|
      result.push(JSON.parse(event.to_json)) if event.date.between?(start_date, end_date)
    end

    halt 200, JSON.pretty_generate(result)
  end

  get '/:year/:state/:city' do
    hp = {
      city: normalize(params[:city]).upcase,
      state: params[:state].upcase,
      year: params[:year],
    }

    holiday = get_holiday(hp)

    halt 200, JSON.pretty_generate(JSON.parse(holiday.to_json))
  end

  private
  def save_holiday(params = {})
    response = get_response(params)

    holiday = Holiday.new

    holiday.year = params[:year]
    holiday.state = response["events"]["location"]["state"]
    holiday.city = response["events"]["location"]["city"]
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

  def get_holiday(params = {})
    holiday = Holiday.where(year: params[:year], state: params[:state], city: params[:city])

    unless holiday.exists?
      holiday = save_holiday(params)
    end

    holiday.first
  end

  def get_response(options = { year: DateTime.now.year, state: '', city: '' })
    query = build_query(options)

    response = HTTParty.get(URI, :query => query)
    data = response.parsed_response

    Hash.from_xml(data)
  end

  def holiday?(date:, holidays:)
    return_hash = holidays.select do |event|
      event_date = Date.strptime(event["date"], "%d/%m/%Y").to_time
      holiday_type = event["type_code"].to_i
      event_date == date && holiday_type != OPTIONAL_DAY_OFF_TYPE && holiday_type != CONVENTIONAL_HOLIDAY_TYPE
    end

    return_hash.length > 0
  end

  def build_query(options = { year: '', state: '', city: ''})
    query = {
      "ano" => options[:year].to_s,
      "estado" => options[:state].to_s,
      "cidade" => options[:city].to_s,
      "token" => TOKEN
    }

    query
  end
end # end-class
