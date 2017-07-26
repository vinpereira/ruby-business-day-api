require 'sinatra'
require 'json'

module AppHelpers
  def normalize(str)
    str.force_encoding('UTF-8').unicode_normalize(:nfkd).encode('ASCII-8BIT', replace: '').gsub(/\s/, '_').upcase
  end

  def city_exists?(state:, city:)
    file = File.read("#{Dir.pwd}/config/estados-cidades.json")

    states_hash = JSON.parse(file)
    state_hash = states_hash['estados'].detect { |s| normalize(s['sigla']) == normalize(state) }

    halt 404, JSON.pretty_generate({ 'message' => 'This state does not exists' }) if state_hash.nil?

    result = state_hash['cidades'].detect { |c| normalize(c) == normalize(city) }

    halt 404, JSON.pretty_generate({ 'message' => 'This city does not exists' }) if result.nil?
  end
end
