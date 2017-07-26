require_relative "#{Dir.pwd}/models/holiday"

RSpec.describe Holiday, type: :model do
	it { is_expected.to be_mongoid_document }

	it { is_expected.to have_field(:year).of_type(String) }
  it { is_expected.to have_field(:city).of_type(String) }
  it { is_expected.to have_field(:state).of_type(String) }
	it { is_expected.to have_field(:country).of_type(String) }
	
	it { is_expected.to embed_many(:events) }

	it { is_expected.to validate_presence_of(:year) }
	it { is_expected.to validate_presence_of(:city) }
	it { is_expected.to validate_presence_of(:state) }
end