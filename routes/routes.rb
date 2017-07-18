# encoding: UTF-8
require 'active_support'
require 'active_support/core_ext'
require 'date'
require 'httparty'
require 'json'
require 'sinatra'
require 'date'

class MyAppRoutes < Sinatra::Base
    URI = URI('http://www.calendario.com.br/api/api_feriados.php')

    before do
        content_type :json
    end

    get '/' do
        get_response()
    end

    get '/:year/:state/:city/range/:start_date/:end_date' do
      query_hash = get_query_hash(year: params[:year], state: params[:state], city: params[:city])

      unless query_hash["events"]["error_msg"]
        start_date = Date.strptime("#{ params[:year] }-#{ params[:start_date] }", "%Y-%m-%d").to_time
        end_date = Date.strptime("#{ params[:year] }-#{ params[:end_date] }", "%Y-%m-%d").to_time

        return_hash = query_hash["events"]["event"].select { |event|
          event_date = Date.strptime(event["date"], "%d/%m/%Y").to_time
          event_date.between?(start_date, end_date)
        }

        JSON.pretty_generate(return_hash)
      else
        JSON.pretty_generate(query_hash)
      end
    end

    get '/:year' do
        get_response(year: params[:year])
    end

    get '/:year/:state' do
        get_response(year: params[:year], state: params[:state])
    end

    get '/:year/:state/:city' do
      get_response(year: params[:year], state: params[:state], city: params[:city])
    end

    def get_response(year: DateTime.now.year, state: '', city: '')
        JSON.pretty_generate(get_query_hash(year: year, state: state, city: city))
    end

    def get_query_hash(year: DateTime.now.year, state: '', city: '')
      token = 'dnAudmluaWNpdXMucGVyZWlyYUBnbWFpbC5jb20maGFzaD0xNTMxMTU2MTc='

      query = build_query(year: year, state: state, city: city, token: token)

      response = HTTParty.get(URI, :query => query)
      data = response.parsed_response

      puts data.encoding

      Hash.from_xml(data)
    end

    def build_query(year:, state:, city:, token:)
        query = {
            "ano" => year.to_s,
            "estado" => state.to_s,
            "cidade" => city.to_s,
            "token" => token.to_s
        }

        query
    end
end
