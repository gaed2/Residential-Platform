class City < ApplicationRecord

  belongs_to :region
  has_many :properties
  enum status: %i[active inactive]

end
