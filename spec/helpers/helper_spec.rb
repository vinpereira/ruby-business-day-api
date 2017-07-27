require_relative "#{Dir.pwd}/helpers/helpers"

# Test suite for the AppHelpers module
RSpec.describe AppHelpers do
  include AppHelpers

	# Test suite for normalize()
	describe "String normalize method" do
		it "gets a String with diacritic, then remove it" do
			expect(normalize('São Paulo')).to eq 'SAO_PAULO'
		end
		
		it "gets a String with diacritic and lowercase, then remove it and return uppercase" do
			expect(normalize('são paulo')).to eq 'SAO_PAULO'
		end
		
		it "gets a String without diacritic and lowercase, then return uppercase" do
			expect(normalize('sao paulo')).to eq 'SAO_PAULO'
		end
		
		it "gets a String with diacritic and uppercase, then remove it" do
			expect(normalize('SÃO PAULO')).to eq 'SAO_PAULO'
		end

		it "gets a String already with underline, without diacritic, and with uppercase, then ignore them" do
			expect(normalize('SAO_PAULO')).to eq 'SAO_PAULO'
		end
	end

	# Need to be done yet
	# Test suite for city_exists?
	describe "City exists method" do
		it "la la la" do
			expect(city_exists? state: 'SP', city: 'São Paulo').to be nil
		end
	end
end