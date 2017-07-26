require_relative "#{Dir.pwd}/models/event"

RSpec.describe Event, type: :model do
	it { is_expected.to be_mongoid_document }

	it { is_expected.to have_field(:date).of_type(Date) }
	it { is_expected.to have_field(:name).of_type(String) }
	it { is_expected.to have_field(:type).of_type(String) }
	it { is_expected.to have_field(:type_code).of_type(Integer) }

	it { is_expected.to be_embedded_in(:holiday) }

	it { is_expected.to validate_presence_of(:date) }
	it { is_expected.to validate_presence_of(:name) }
	it { is_expected.to validate_presence_of(:type_code) }
end