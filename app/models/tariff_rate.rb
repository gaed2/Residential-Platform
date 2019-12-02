class TariffRate < ApplicationRecord

  enum tariff_type: ['electricity', 'water', 'gas']

end
