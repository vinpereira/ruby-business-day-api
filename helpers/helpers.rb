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
    
    if state_hash.nil?
      return false
    else
      result = state_hash['cidades'].detect { |c| normalize(c) == normalize(city) }
      return ! result.nil?
    end
  end
end
