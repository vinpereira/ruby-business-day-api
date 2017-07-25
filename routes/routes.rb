# encoding: UTF-8
require 'active_support'
require 'active_support/core_ext'
require 'date'
require 'json'
require 'sinatra'
require 'sinatra/namespace'

require_relative "#{Dir.pwd}/controllers/holiday_controller"
require_relative "#{Dir.pwd}/helpers/helpers"

class AppRoutes < Sinatra::Application
  register Sinatra::Namespace

  helpers AppHelpers

  namespace '/api/v1/:state/:city' do
    before do
      content_type :json

      city_exists? state: params[:state], city: params[:city]

      @holiday_params = { city: normalize(params[:city]), state: normalize(params[:state]) }
      @holiday_controller = HolidayController.new
    end

    get '/holiday/:date' do
      date = Date.strptime("#{ params[:date] }", "%Y-%m-%d")

      @holiday_params[:year] = date.year

      halt 200, JSON.pretty_generate({ holiday: @holiday_controller.holiday?(@holiday_params) })
    end

    get '/:year/range/:start_date/:end_date' do
      start_date = Date.strptime("#{ params[:year] }-#{ params[:start_date] }", "%Y-%m-%d")
      end_date = Date.strptime("#{ params[:year] }-#{ params[:end_date] }", "%Y-%m-%d")

      @holiday_params[:year] = params[:year]
      @holiday_params[:start] = start_date
      @holiday_params[:end] = end_date

      result = @holiday_controller.range(@holiday_params)

      halt 200, JSON.pretty_generate(result)
    end

    get '/?:year?' do
      @holiday_params[:year] = params[:year] || Time.now.year

      holiday = @holiday_controller.get(@holiday_params)

      halt 200, JSON.pretty_generate(JSON.parse(holiday.to_json))
    end
  end
end # end-class
