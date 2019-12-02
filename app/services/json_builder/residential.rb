class JsonBuilder::Residential < JsonBuilder
  def energy_data
    @property.energy_data.collect do |energy_datum|
      {
        cost_in_sdg:  energy_datum.cost_in_dollar,
        month_year:   "#{energy_datum.month}/#{energy_datum.year}",
        consumption:  energy_datum.energy_consumption.to_f
      }
    end
  end

  def electricity_consumption_equipments
    @property.electricity_consumption_equipments.collect do |equipment|
      {
        name:                    equipment.name,
        year_installed:          equipment.year_installed,
        electricity_consumption: equipment.electricity_consumption,
        location:                equipment.location
      }
    end
  end

  def property_checklists
    @property.property_checklists.collect do |checklist|
      {
        title: checklist.energy_saving_checklist.heading,
        question: checklist.energy_saving_checklist.question,
        answer: checklist.answer
      }
    end
  end

  def equipment_maintenances
    @property.equipment_maintenances.collect do |equipment|
      {
        equipment_or_appliance: equipment.name,
        upgraded_year:          "#{equipment.last_upgraded_month}/#{equipment.last_upgraded_year}",
        frequency:              equipment.frequency
      }
    end
  end

  def past_year_utility_bills; end

  def renewable_energy_sources
    @property.renewable_energy_sources.collect { |source| { name: source.name, type: source.source_type } }
  end

  def fetch_general_details
    [property_data.merge!(
      renewable_energy_sources: renewable_energy_sources
      ).to_json, SecureRandom.hex]
  end

  def fetch_energy_data_details
    [{
        electricity_supplier: @property.current_electricity_supplier&.name,
        supplier_duration: @property.current_supplier_duration,
        energy_data_details: energy_data,
        electricity_consumption_equipments: electricity_consumption_equipments,
        installed_renewable_energy_source: @property.other_consumptions_in_kwh
    }.to_json, SecureRandom.hex]
  end

  def fetch_checklist_details
    [{
        property_checklists: property_checklists,
        equipment_maintenances: equipment_maintenances
    }.to_json, SecureRandom.hex]
  end

  def fetch_recommendations_details
    best_plan = recommendations.first
    best_plan_hash = {
      retailer_with_min_bill: best_plan.electricity_supplier.name,
      saving_per_month: "$ #{@property.avg_monthly_electricity_bill - best_plan.estimated_cost.round(2)}"
    }
    [[].push(basic_details, best_three_plans, best_plan_hash).to_json, SecureRandom.hex]
  end

  def recommendations
    @property.top_three_retailers
  end

  def basic_details
    {
      property_category: @property.category_name,
      property_address: @property.address,
      property_sub_category: @property.property_sub_category&.name,
      property_avg_monthly_consumption: "#{@property.avg_monthly_electricity_consumption} KWH",
      current_supplier_name: (@property&.current_electricity_supplier&.name || 'NA')
    }
  end

  def best_three_plans
    recommendations.inject([]) do |plan_array, plan|
      plan_array.push(
        plan_supplier_name: plan&.electricity_supplier&.name,
        plan_name: plan.name,
        plan_type: plan.plan_type,
        plan_duration: "#{plan.contract_duration} months",
        regulated_rate: "#{@property.current_regulated_rate * 100} Cents/KWh",
        electric_city_rate: "#{plan.price} #{plan.price_in}",
        estimated_bill: "$#{plan.estimated_cost}"
      )
    end
  end

  def property_data
    {
      owner_name:               @property.owner_name,
      owner_email:              @property.owner_email,
      contact_number:           @property.contact_number,
      full_address:             @property.full_address,
      adults:                   @property.adults,
      senior_citizens:          @property.senior_citizens,
      children:                 @property.children,
      duration_of_stay:         @property.duration_of_stay,
      bedrooms:                 @property.bedrooms,
      floors:                   @property.floors,
      bathrooms:                @property.bathrooms,
      avg_room_size:            @property.avg_room_size,
      living_room_size:         @property.living_room_size,
      dining_room_size:         @property.dining_room_size,
      total_house_size:         @property.total_house_size,
      floor_cieling_height:     @property.floor_cieling_height,
      roof_length:              @property.roof_length,
      roof_breadth:             @property.roof_breadth,
      at_home_time:             @property.at_home_time,
      full_time_occupancy:      @property.full_time_occupancy,
      ac_usage:                 @property.ac_usage_time,
      ac_units:                 @property.ac_units,
      ac_temperature:           @property.ac_temperature,
      electricity_consumption:  @property.electricity_consumption,
      natural_gas_consumption:  @property.natural_gas_consumption,
      other_consumptions:       @property.other_consumptions,
      water_consumption:        @property.water_consumption
    }
  end
end
