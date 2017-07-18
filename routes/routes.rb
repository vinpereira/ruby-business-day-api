# encoding: UTF-8
require 'active_support'
require 'active_support/core_ext'
require 'date'
require 'httparty'
require 'json'
require 'sinatra'

class MyAppRoutes < Sinatra::Base
    URI = URI('http://www.calendario.com.br/api/api_feriados.php')

    before do
        content_type :json
    end

    get '/' do
        get_response()
    end

    get '/year/:year' do
        get_response(year: params[:year])
    end

    get '/state/:state' do
        get_response(state: params[:state])
    end

    def get_response(year: DateTime.now.year, state: '', city: '')
        token = 'dnAudmluaWNpdXMucGVyZWlyYUBnbWFpbC5jb20maGFzaD0xNTMxMTU2MTc='

        query = build_query(year: year, state: state, city: city, token: token)

        response = HTTParty.get(URI, :query => query)
        data = response.parsed_response

        puts data.encoding

        JSON.pretty_generate(Hash.from_xml(data))
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
