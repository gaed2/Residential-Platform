namespace :energy_saving_checklist do
  desc "update energy saving checklist"
  task update: :environment do
    checklist = { 'Energy Management': 'Is there a good management of the energy consumption?',
                  'Heating/Hot Water': 'Is the domestic water temperature controlled/used often?',
                  'Lightning': 'Is the use of lightning optimised?',
                  'Ventilation': 'Is there adequate ventilation?',
                  'Air Conditioning': 'Is the AC system running at optimised/manufacturers settings?',
                  'Occupant knowledge and Behaviour': 'Are the occupants educated and aware in energy savings?',
                  'Energy usage': 'Do you have Smart plugs and power meter installed to monitor the energy usage of the appliances?',
                  'WELS 3': 'Do you have WELS 3 standard tap installed or any water saving inserts in taps?',
                  'Old Air Conditioning': 'Is the current Air conditioning system is an old non-inverter set?',
                  'Windows': 'Are windows tinted to reduce glare fom the sun?'
    }

    checklist.each do |heading, question|
      EnergySavingChecklist.create!(heading: heading, question: question)
    end
  end
end
