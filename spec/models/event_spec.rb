require_relative "#{Dir.pwd}/models/event"

RSpec.configure {|c| c.deprecation_stream = "#{Dir.pwd}/logs/deprecations.txt" }

# Test suite for the Event model
RSpec.describe Event, type: :model do
	# Document type test
	# ensure that Event model is a Mongoid document
	it { is_expected.to be_mongoid_document }

	# Fields tests
	# ensure field date is Date
	# ensure fields name and type are String
	# ensure field type_code is Integer
	it { is_expected.to have_field(:date).of_type(Date) }
	it { is_expected.to have_field(:name).of_type(String) }
	it { is_expected.to have_field(:type).of_type(String) }
	it { is_expected.to have_field(:type_code).of_type(Integer) }

	# Association test
	# ensure Event model is embedded in the Holiday model
	it { is_expected.to be_embedded_in(:holiday) }

	# Validation tests
  # ensure fields date, name, and type_code are present before saving
	it { is_expected.to validate_presence_of(:date) }
	it { is_expected.to validate_presence_of(:name) }
	it { is_expected.to validate_presence_of(:type_code) }
end