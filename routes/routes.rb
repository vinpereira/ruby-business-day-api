# encoding: UTF-8
require 'active_support'
require 'active_support/core_ext'
require 'date'
require 'httparty'
require 'json'
require 'sinatra'

class MyAppRoutes < Sinatra::Base
  URI = URI('http://www.calendario.com.br/api/api_feriados.php')
  TOKEN = 'dnAudmluaWNpdXMucGVyZWlyYUBnbWFpbC5jb20maGFzaD0xNTMxMTU2MTc='
  OPTIONAL_DAY_OFF_TYPE = 4       # Code 4 is for 'Ponto Facultativo' -- a optional holiday (like Carnival)
  CONVENTIONAL_HOLIDAY_TYPE = 9   # Code 9 is for 'Dia Convencional' -- a festive day that may or may not be a holiday (depends of each city)

  before do
    content_type :json
  end

  get '/:state/:city/holiday/:date' do
    date = Date.strptime("#{ params[:date] }", "%Y-%m-%d").to_time
    params[:year] = date.year

    query_hash = get_response(params)

    unless query_hash["events"]["error_msg"]
      JSON.pretty_generate({holiday: holiday?(date: date, holidays: query_hash["events"]["event"]) })
    else
      JSON.pretty_generate(query_hash)
    end
  end

  get '/:year/:state/:city/range/:start_date/:end_date' do
    query_hash = get_response(params)

    unless query_hash["events"]["error_msg"]
      start_date = Date.strptime("#{ params[:year] }-#{ params[:start_date] }", "%Y-%m-%d").to_time
      end_date = Date.strptime("#{ params[:year] }-#{ params[:end_date] }", "%Y-%m-%d").to_time

      return_hash = query_hash["events"]["event"].select do |event|
        event_date = Date.strptime(event["date"], "%d/%m/%Y").to_time
        event_date.between?(start_date, end_date)
      end

      JSON.pretty_generate(return_hash)
    else
      JSON.pretty_generate(query_hash)
    end
  end

  get '/?:year?/?:state?/?:city?' do
    JSON.pretty_generate(get_response(params))
  end

  private

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
