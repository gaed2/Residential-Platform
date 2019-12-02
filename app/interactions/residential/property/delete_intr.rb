# frozen_string_literal: true

class Residential::Property::DeleteIntr < ApplicationInteraction
  string :entity
  integer :entity_id, default: nil
  object :property

  def execute 
    if entity == 'equipment_list_and_specification'
      property.remove_equipment_list_and_specification!
      return errors.merge!  property.errors unless property.save
    elsif entity == 'electrical_distribution_schematic_diagram'
      property.remove_electrical_distribution_schematic_diagram!
      return errors.merge!  property.errors unless property.save
    else
      model = entity.constantize.find(entity_id)
      return errors.add(:monthly_data, I18n.t('energy_data.delete_error')) if (entity == 'EnergyDatum' && property.count_energy_data < 2)
      return errors.merge! model.errors unless model.destroy
    end
    property
  end

end
