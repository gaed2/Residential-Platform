class PropertyChecklist < ApplicationRecord
  belongs_to :property
  belongs_to :energy_saving_checklist
end
