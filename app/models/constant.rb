# frozen_string_literal: true
class Constant

  USER_NAME_FORMAT = /\A[(a-zA-Z)\'.-]{1,70}\z/
  DEFAULT_USER_AVATAR = "default-user.png"
  CHECKLIST_SEQUENCE = ('A'..'Z').to_a
  PLAN_TYPES = { 'Fixed Price': 'fixed',
                 'Discount Off Regulated Tariff': 'discount_off',
                 'Peak and Off-Peak': 'peak_and_off_peak' }.freeze
  TOP_PLANS_LIMIT = 30
  HOME_TIME_FORMAT = '%I:%M %p'
  TIME_PICKER_FORMAT = "%H:%M"
  YEAR_FORMAT = '%Y'
  MONTH_FORMAT = '%B'
  MONTH_YEAR_FORMAT = '%B %Y'
  AVG_PEAK_CONSUMPTION = 0.7
  VALID_IMG_EXTENSIONS = %w[jpg jpeg png].freeze
  EQUIPMENT_LOCATION = ['Bedroom', 'Master Bedroom', 'Living Room', 'Dining Room', 'Kitchen', 'Washroom', 'Laundry Room']
  MONTHS = [['January', 1], ['February', 2], ['March', 3], ['April', 4], ['May', 5], ['June', 6], ['July', 7],
            ['August', 8], ['September', 9], ['October', 10], ['November', 11], ['December', 12]]
  MINIMUM_CHARACTER_FOR_SEARCH = 3
  PROPERTY_PER_PAGE = 5
  EDIT_ENERGY_DATA_PARTIALS = ['edit_energy_data', 'edit_energy_save_checklist', 'edit_general_details']
  EQUIPMENTS = ['Aircon', 'Air conditioning system', 'Hot Water system', 'Lighting', 'Refrigeration', 'Kitchen Cooking', 'Washing Machine', 'Dryer', 'TV', 'Smart Home System']
  EQUIPMENTS_HASH = {ac: 'Air conditioning system', aircon: 'Aircon', tv: 'TV', fridge: 'Refrigeration', ls: 'Lighting system', hw: 'Hot Water system', shs: 'Smart Home System', wm: 'Washing Machine', dr: 'Dryer'}
  EQUIPMENT_TYPES = ['Plasma', 'Fluorescent', 'Other']
  TV_TYPES = ['Plasma', 'LED', 'LCD']
  TV_TYPES_PLACEHOLDER = 'E.g Plasma, LED, LCD'
  WASHING_MACHINE_TYPES = ['Top loading', 'Front Loading', 'Other']
  LENGTH_UNIT = [['sq. m.'], ['sq. ft.']]
  LENGTH_UNIT_ONLY = [['metre'], ['feet']]
  ELECTRICITY_UNIT = [['kWh']]
  WATER_UNIT = [['cbm'], ['cbf']]
  GAS_UNIT = [['cbm'], ['cbf']]
  ENERGY_RENEWABLE_SOURCES = [['Generator'], ['Solar'], ['Other']]
  UTILITY_BILLS_TYPE = [['Electrical'], ['Water'], ['Gas'], ['Other']]
  DEFAULT_PLAN_LIMIT = 3
  EQUIPMENT_VALIDITY_YEAR = 2015
  DEFAULT_RATING = 1
  TOTAL_BILL_SAVING_YEARS = 25
  DEFAULT_ROOF_LENGTH = 10
  DEFAULT_ROOF_WIDTH = 5
  TARRIF_RATE_FLUCTUATION = 101
  ENERGY_FLUCTUATION = 99.5
  CARBON_RATIO = 0.28307
  SP_GROUP_ELECTRICITY_RATE = 24.22
  SUPPLIER_DATE_FORMAT = "%d/%m/%Y"
  ASSESSMENT_DATE_TIME_FORMAT = "%d/%m/%Y at %I:%M%p"
  AVERAGE_APPLIANCE_CONSUMPTION = [
                                    { name: "25' colour CRT TV", min_consumption: '150W', max_consumption: '150W', standby: '1W', other_name: ''},
                                    { name: "32 Inch LED TV", min_consumption: '20W', max_consumption: '60W', standby: '1W', other_name: ''},
                                    { name: "46 Inch LED TV", min_consumption: '60W', max_consumption: '70W', standby: '1W', other_name: ''},
                                    { name: "49 Inch LED TV", min_consumption: '85W', max_consumption: '85W', standby: '1W', other_name: ''},
                                    { name: "60W light bulb (Incandescent)", min_consumption: '60W', max_consumption: '60W', standby: '0W', other_name: ''},
                                    { name: "American-style Fridge Freezer", min_consumption: '40W', max_consumption: '50W', standby: 'N/A', other_name: '2-door Fridge'},
                                    { name: "Ceiling Fan", min_consumption: '60W', max_consumption: '70W', standby: '0W', other_name: ''},
                                    { name: "Clock radio", min_consumption: '1W', max_consumption: '2W', standby: 'N/A', other_name: ''},
                                    { name: "Clothes Dryer", min_consumption: '1000W', max_consumption: '4000W', standby: 'N/A', other_name: 'Tumble Dryer'},
                                    { name: "Coffee Maker", min_consumption: '800W', max_consumption: '1400W', standby: 'N/A', other_name: ''},
                                    { name: "Computer Monitor", min_consumption: '25W', max_consumption: '30W', standby: 'N/A', other_name: ''},
                                    { name: "Cooker Hood", min_consumption: '20W', max_consumption: '30W', standby: '0W', other_name: ''},
                                    { name: "Corded Drill", min_consumption: '600W', max_consumption: '850W', standby: 'N/A', other_name: ''},
                                    { name: "Cordless Drill Charger", min_consumption: '70W', max_consumption: '150W', standby: 'N/A', other_name: ''},
                                    { name: "Curling Iron", min_consumption: '25W', max_consumption: '35W', standby: '0W', other_name: ''},
                                    { name: "DAB Mains Radio", min_consumption: '5W', max_consumption: '9W', standby: 'N/A', other_name: 'Digital Radio'},
                                    { name: "Desktop Computer", min_consumption: '100W', max_consumption: '450W', standby: 'N/A', other_name: ''},
                                    { name: "Dishwasher", min_consumption: '1200W', max_consumption: '1500W', standby: 'N/A', other_name: ''},
                                    { name: "Domestic Water Pump", min_consumption: '200W', max_consumption: '300W', standby: '0W', other_name: 'Shower Water Pump'},
                                    { name: "DVD Player", min_consumption: '26W', max_consumption: '60W', standby: 'N/A', other_name: ''},
                                    { name: "Electric Kettle", min_consumption: '1200W', max_consumption: '3000W', standby: '0W', other_name: ''},
                                    { name: "Electric Mower", min_consumption: '1500W', max_consumption: '1500W', standby: 'N/A', other_name: ''},
                                    { name: "Electric Shaver", min_consumption: '15W', max_consumption: '20W', standby: 'N/A', other_name: ''},
                                    { name: "Electric Stove", min_consumption: '800W', max_consumption: '1000W', standby: 'N/A', other_name: ''},
                                    { name: "Electric Tankless Water Heater", min_consumption: '6600W', max_consumption: '8800W', standby: 'N/A', other_name: ''},
                                    { name: "Espresso Coffee Machine", min_consumption: '1300W', max_consumption: '1500W', standby: 'N/A', other_name: 'Espresso Machine'},
                                    { name: "Extractor Fan", min_consumption: '12W', max_consumption: '12W', standby: 'N/A', other_name: ''},
                                    { name: "Food Blender", min_consumption: '300W', max_consumption: '400W', standby: 'N/A', other_name: "Mixer,Food Processor"},
                                    { name: "Food Dehydrator", min_consumption: '800W', max_consumption: '800W', standby: 'N/A', other_name: 'Tray Dehydrator'},
                                    { name: "Freezer", min_consumption: '30W', max_consumption: '50W', standby: 'N/A', other_name: 'Espresso Machine'},
                                    { name: "Fridge / Freezer", min_consumption: '150W', max_consumption: '400W', standby: 'N/A', other_name: 'Old-style fridge'},
                                    { name: "Fryer", min_consumption: '1000W', max_consumption: '1000W', standby: 'N/A', other_name: 'Deep  Fryer'},
                                    { name: "Game Console", min_consumption: '120W', max_consumption: '200W', standby: 'N/A', other_name: ''},
                                    { name: "Gaming PC", min_consumption: '300W', max_consumption: '600W', standby: '1W', other_name: 'Gaming Computer'},
                                    { name: "Garage Door Opener", min_consumption: '300W', max_consumption: '400W', standby: 'N/A', other_name: 'Electric Garage Door'},
                                    { name: "Guitar Amplifier", min_consumption: '20W', max_consumption: '30W', standby: 'N/A', other_name: ''},
                                    { name: "Hair Blow Dryer", min_consumption: '1800W', max_consumption: '2500W', standby: "N/A Blow Dryer, Hair Dryer"},
                                    { name: "Home Non-Inverter Air Conditioner", min_consumption: '1000W', max_consumption: '4000W', standby: 'N/A', other_name: ''},
                                    { name: "Home Internet Router", min_consumption: '5W', max_consumption: '15W', standby: 'N/A', other_name: ''},
                                    { name: "Home Phone", min_consumption: '3W', max_consumption: '5W', standby: '2W DECT Telephone', other_name: ''},
                                    { name: "Home Sound System", min_consumption: '95W', max_consumption: '95W', standby: '1W', other_name: ''},
                                    { name: "Hot Water Dispenser", min_consumption: '1200W', max_consumption: '1300W', standby: 'N/A', other_name: ' Instant Hot Water Tap'},
                                    { name: "Humidifier", min_consumption: '35W', max_consumption: '40W', standby: 'N/A', other_name: ''},
                                    { name: "Induction Hob (per hob)", min_consumption: '1400W', max_consumption: '1800W', standby: 'N/A', other_name: ' Induction Stove, Induction Cooking Stove'},
                                    { name: "Inkjet Printer", min_consumption: '20W', max_consumption: '30W', standby: 'N/A', other_name: 'Printer'},
                                    { name: "Inverter Air conditioner", min_consumption: '1300W', max_consumption: '1800W', standby: 'N/A', other_name: ''},
                                    { name: "Iron", min_consumption: '1000W', max_consumption: '1000W', standby: 'N/A', other_name: 'Electric Iron'},
                                    { name: "Laptop Computer", min_consumption: '50W', max_consumption: '100W', standby: 'N/A', other_name: 'Laptop'},
                                    { name: "Lawnmower", min_consumption: '1000W', max_consumption: '1400W', standby: 'N/A', other_name: ''},
                                    { name: "LED Light Bulb", min_consumption: '7W', max_consumption: '10W', standby: '0W', other_name: 'Energy Saver Bulb'},
                                    { name: "TV Box", min_consumption: '5W', max_consumption: '7W', standby: '3W', other_name: 'Android Box / Apple Box'},
                                    { name: "Microwave", min_consumption: '600W', max_consumption: '1700W', standby: '3W', other_name: ''},
                                    { name: "Night Light", min_consumption: '1W', max_consumption: '1W', standby: '0W', other_name: ''},
                                    { name: "Oven", min_consumption: '2150W', max_consumption: '2150W', standby: 'N/A', other_name: 'Electric Oven'},
                                    { name: "Paper Shredder", min_consumption: '200W', max_consumption: '220W', standby: 'N/A', other_name: ''},
                                    { name: "Pedestal Fan", min_consumption: '50W', max_consumption: '60W', standby: 'N/A', other_name: ''},
                                    { name: "Percolator", min_consumption: '800W', max_consumption: '1100W', standby: 'N/A', other_name: 'Coffee Maker'},
                                    { name: "Phone Charger", min_consumption: '4W', max_consumption: '7W', standby: 'N/A', other_name: 'Smart Phone Charger'},
                                    { name: "Power Shower", min_consumption: '7500W', max_consumption: '10500W', standby: '0W', other_name: 'Electric Water heater with Pump'},
                                    { name: "Pressure Cooker", min_consumption: '700W', max_consumption: '700W', standby: 'N/A', other_name: ''},
                                    { name: "Projector", min_consumption: '220W', max_consumption: '270W', standby: '1W', other_name: ''},
                                    { name: "Rice Cooker", min_consumption: '200W', max_consumption: '500W', standby: 'N/A', other_name: ''},
                                    { name: "Sandwich Maker", min_consumption: '700W', max_consumption: '1000W', standby: 'N/A', other_name: 'Sandwich Press, Sandwich Toaster'},
                                    { name: "Scanner", min_consumption: '10W', max_consumption: '18W', standby: 'N/A', other_name: ''},
                                    { name: "Sewing Machine", min_consumption: '70W', max_consumption: '80W', standby: 'N/A', other_name: ''},
                                    { name: "Slow Cooker", min_consumption: '160W', max_consumption: '180W', standby: 'N/A', other_name: ''},
                                    { name: "Steriliser", min_consumption: '650W', max_consumption: '650W', standby: 'N/A', other_name: 'Sterilizer'},
                                    { name: "Straightening Iron", min_consumption: '75W', max_consumption: '300W', standby: 'N/A', other_name: 'Hair Straighteners'},
                                    { name: "Strimmer", min_consumption: '300W', max_consumption: '500W', standby: 'N/A', other_name: ''},
                                    { name: "Table Fan", min_consumption: '10W', max_consumption: '25W', standby: 'N/A', other_name: 'Dest Fan'},
                                    { name: "Tablet Charger", min_consumption: '10W', max_consumption: '15W', standby: 'N/A', other_name: ''},
                                    { name: "Tablet Computer", min_consumption: '5W', max_consumption: '10W', standby: 'N/A', other_name: ''},
                                    { name: "Toaster", min_consumption: '800W', max_consumption: '1800W', standby: '0W', other_name: ''},
                                    { name: "Treadmill", min_consumption: '280W', max_consumption: '900W', standby: 'N/A', other_name: ''},
                                    { name: "Flourescent Light (1500mm)", min_consumption: '22W', max_consumption: '22W', standby: 'N/A', other_name: ''},
                                    { name: "Vacuum Cleaner", min_consumption: '700W', max_consumption: '900W', standby: '0W', other_name: ''},
                                    { name: "Wall Fan", min_consumption: '45W', max_consumption: '60W', standby: '0W', other_name: ''},
                                    { name: "Washing Machine", min_consumption: '500W', max_consumption: '500W', standby: '1W', other_name: ''} ,
                                    { name: "Water Dispenser", min_consumption: '100W', max_consumption: '100W', standby: 'N/A', other_name: ''},
                                    { name: "Water Feature", min_consumption: '35W', max_consumption: '35W', standby: 'N/A', other_name: ''},
                                    { name: "Water Filter and Cooler", min_consumption: '70W', max_consumption: '100W', standby: 'N/A', other_name: ''},
                                    { name: "Wine cooler (18 bottles)", min_consumption: '83W', max_consumption: '83W', standby: '0W', other_name: ''}
                                  ]


end
