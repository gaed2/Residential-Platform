require 'rails_helper'

RSpec.describe City, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  city = City.new
  it { expect(city).to belong_to(:region) }
  it { expect(city).to have_many(:properties) }
end
