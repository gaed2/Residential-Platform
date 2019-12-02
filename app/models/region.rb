class Region < ApplicationRecord

  has_many :cities
  enum status: %i[active inactive]

end
