require_relative "#{Dir.pwd}/models/holiday"

RSpec.configure {|c| c.deprecation_stream = "#{Dir.pwd}/logs/deprecations.txt" }

# Test suite for the Holiday model
RSpec.describe Holiday, type: :model do
	# Document type test
	# ensure that Holiday model is a Mongoid document
	it { is_expected.to be_mongoid_document }

	# Fields tests
  # ensure fields year, city, state, and country are String
	it { is_expected.to have_field(:year).of_type(String) }
  it { is_expected.to have_field(:city).of_type(String) }
  it { is_expected.to have_field(:state).of_type(String) }
	it { is_expected.to have_field(:country).of_type(String) }
	
	# Association test
	# ensure Holiday model has an embed many relationship with the Event model
	it { is_expected.to embed_many(:events) }

	# Validation tests
  # ensure fields year, city, and state are present before saving
	it { is_expected.to validate_presence_of(:year) }
	it { is_expected.to validate_presence_of(:city) }
	it { is_expected.to validate_presence_of(:state) }
end