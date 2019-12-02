# frozen_string_literal: true

namespace :supplier_and_their_plans do
  desc 'Update Suppliers Plan'
  task create: :environment do
    plans = { 'Best Electricity Supply': [{ name: 'BEST Home Fixed 6 months', plan_type: :fixed, price_type: :unit, price: 19.58, contract_duration: 6, tariff_allow: true },
                                               { name: 'BEST Home Fixed 12 months', plan_type: :fixed, price_type: :unit, price: 19, contract_duration: 12, tariff_allow: true },
                                               { name: 'BEST Home Fixed 24 months', plan_type: :fixed, price_type: :unit, price: 17.98, contract_duration: 24, tariff_allow: true },
                                               { name: 'BEST Home Saver 12 months', plan_type: :discount_off, price_type: :percentage, price: 15, contract_duration: 12, tariff_allow: true },
                                               { name: 'BEST Home Saver 24 months', plan_type: :discount_off, price_type: :percentage, price: 21, contract_duration: 24, tariff_allow: true }],

                   'Diamond Electric': [{ name: 'Sure Save Plus Rebate – RES', plan_type: :discount_off, price_type: :percentage, price: 22.5, contract_duration: 12, tariff_allow: true }],

                   'Environmental Solutions (Asia)': [{ name: 'GLOCKED (Carbon Neutral)', plan_type: :fixed, price_type: :unit, price: 19.45, contract_duration: 12, tariff_allow: true },
                                                      { name: 'GLOCKED (Carbon Neutral)', plan_type: :fixed, price_type: :unit, price: 18.14, contract_duration: 24, tariff_allow: true },
                                                      { name: 'GFREEDOM (Carbon Neutral)', plan_type: :discount_off, price_type: :percentage, price: 21.5, contract_duration: 12, tariff_allow: true },
                                                      { name: 'GFREEDOM (Carbon Neutral)', plan_type: :discount_off, price_type: :percentage, price: 22, contract_duration: 24, tariff_allow: true }],

                   'iSwitch': [{ name: "Chope’ The Rate (12 Months)", plan_type: :fixed, price_type: :unit, price: 17.66, contract_duration: 12, tariff_allow: true },
                               { name: "Chope’ The Rate (24 Months)", plan_type: :fixed, price_type: :unit, price: 17.56, contract_duration: 24, tariff_allow: true },
                               { name: 'Super Saver Discount (12 Months)', plan_type: :discount_off, price_type: :percentage, price: 22.8, contract_duration: 12, tariff_allow: true },
                               { name: 'Super Saver Discount (24 Months)', plan_type: :discount_off, price_type: :percentage, price: 23, contract_duration: 24, tariff_allow: true }],

                    'Keppel Electric': [{ name: 'FIXED12', plan_type: :fixed, price_type: :unit, price: 18.71, contract_duration: 12, tariff_allow: true },
                                        { name: 'FIXED24', plan_type: :fixed, price_type: :unit, price: 17.98, contract_duration: 24, tariff_allow: true },
                                        { name: 'DOT 3', plan_type: :discount_off, price_type: :percentage, price: 22, contract_duration: 24, tariff_allow: true },
                                        { name: 'DOT 24', plan_type: :discount_off, price_type: :percentage, price: 22, contract_duration: 24, tariff_allow: true }],

                    'Ohm Energy': [{ name: 'Fixed Ohm (6 Months)', plan_type: :fixed, price_type: :unit, price: 18.35, contract_duration: 6, tariff_allow: true },
                                   { name: 'Fixed Ohm (12 Months)', plan_type: :fixed, price_type: :unit, price: 18.03, contract_duration: 12, tariff_allow: true },
                                   { name: 'Fixed Ohm (24 Months)', plan_type: :fixed, price_type: :unit, price: 17.98, contract_duration: 24, tariff_allow: true },
                                   { name: 'Ohm Discount (6 Months)', plan_type: :discount_off, price_type: :percentage, price: 25, contract_duration: 6, tariff_allow: true },
                                   { name: 'Ohm Discount (12 Months)', plan_type: :discount_off, price_type: :percentage, price: 25, contract_duration: 12, tariff_allow: true }],

                    'PacificLight Energy': [{ name: 'Stick To It 12m', plan_type: :fixed, price_type: :unit, price: 19.08, contract_duration: 12, tariff_allow: true },
                                            { name: 'Stick To It 24m', plan_type: :fixed, price_type: :unit, price: 17.97, contract_duration: 24, tariff_allow: true },
                                            { name: 'Confirm Save 12m', plan_type: :discount_off, price_type: :percentage, price: 21, contract_duration: 12, tariff_allow: true },
                                            { name: 'Confirm Save 24m', plan_type: :discount_off, price_type: :percentage, price: 21, contract_duration: 24, tariff_allow: true }],

                    'Sembcorp Power': [{ name: '12M Fixed Price Home', plan_type: :fixed, price_type: :unit, price: 18.56, contract_duration: 12, tariff_allow: true },
                                       { name: '24M Fixed Price Home', plan_type: :fixed, price_type: :unit, price: 17.98, contract_duration: 24, tariff_allow: true },
                                       { name: '12M Discount off Regulate Tariff Plan', plan_type: :discount_off, price_type: :percentage, price: 21, contract_duration: 12, tariff_allow: true },
                                       { name: '24M Discount off Regulate Tariff Plan', plan_type: :discount_off, price_type: :percentage, price: 21.8, contract_duration: 24, tariff_allow: true }],

                    'Senoko Energy': [{ name: 'LifePower12 (18.94)', plan_type: :fixed, price_type: :unit, price: 18.94, contract_duration: 12, tariff_allow: true },
                                       { name: 'LifePower24 (18.46)', plan_type: :fixed, price_type: :unit, price: 17.95, contract_duration: 24, tariff_allow: true },
                                       { name: 'LifeSave12 (14.5%)', plan_type: :discount_off, price_type: :percentage, price: 14.5, contract_duration: 12, tariff_allow: true },
                                       { name: 'LifeEnergy24 (17.25%)', plan_type: :discount_off, price_type: :percentage, price: 17.25, contract_duration: 24, tariff_allow: true }],

                    'Geneco by Seraya Energy': [{ name: 'Get It Fixed 12', plan_type: :fixed, price_type: :unit, price: 20.33, contract_duration: 12, tariff_allow: true },
                                                { name: 'Get It Fixed 24', plan_type: :fixed, price_type: :unit, price: 17.98, contract_duration: 24, tariff_allow: true },
                                                { name: 'Give Us A Try', plan_type: :discount_off, price_type: :percentage, price: 20, contract_duration: 6, tariff_allow: true },
                                                { name: 'Get It Less 24', plan_type: :discount_off, price_type: :percentage, price: 22, contract_duration: 24, tariff_allow: true }],

                    'Sunseap Energy': [{ name: 'SUNSEAP-ONE (1% Solar Energy) 6M', plan_type: :fixed, price_type: :unit, price: 18.03, contract_duration: 6, tariff_allow: true },
                                       { name: 'SUNSEAP-ONE (1% Solar Energy) 12M', plan_type: :fixed, price_type: :unit, price: 18.48, contract_duration: 12, tariff_allow: true },
                                       { name: 'SUNSEAP-ONE (1% Solar Energy) 24M', plan_type: :fixed, price_type: :unit, price: 17.98, contract_duration: 24, tariff_allow: true },
                                       { name: 'SUNSEAP-50 (50% Solar Energy) 24M', plan_type: :fixed, price_type: :unit, price: 21.61, contract_duration: 24, tariff_allow: true },
                                       { name: 'SUNSEAP-100 (100% Solar Energy) 24M', plan_type: :fixed, price_type: :unit, price: 23.01, contract_duration: 24, tariff_allow: true },
                                       { name: 'SUNSEAP-ONE (1% Solar Energy) 6M', plan_type: :discount_off, price_type: :percentage, price: 23, contract_duration: 6, tariff_allow: true },
                                       { name: 'SUNSEAP-ONE (1% Solar Energy) 12M', plan_type: :discount_off, price_type: :percentage, price: 23, contract_duration: 12, tariff_allow: true },
                                       { name: 'SUNSEAP-ONE (1% Solar Energy) 24M', plan_type: :discount_off, price_type: :percentage, price: 23, contract_duration: 24, tariff_allow: true },
                                       { name: 'SUNSEAP-50 (50% Solar Energy) 24M', plan_type: :discount_off, price_type: :percentage, price: 15, contract_duration: 24, tariff_allow: true },
                                       { name: 'SUNSEAP-100 (100% Solar Energy) 24M', plan_type: :discount_off, price_type: :percentage, price: 10, contract_duration: 24, tariff_allow: true }],

                    'Tuas Power Supply': [{ name: 'PowerDO 6', plan_type: :discount_off, price_type: :unit, price: 18, contract_duration: 6, tariff_allow: true },
                                          { name: 'PowerDO 24', plan_type: :discount_off, price_type: :unit, price: 21, contract_duration: 24, tariff_allow: true }],

                    'Union Power': [{ name: 'Basic Pack – 24', plan_type: :fixed, price_type: :percentage, price: 18, contract_duration: 24, tariff_allow: true },
                                    { name: 'Value Saver 12', plan_type: :discount_off, price_type: :percentage, price: 19, contract_duration: 12, tariff_allow: true },
                                    { name: 'Dual Value Saver', plan_type: :discount_off, price_type: :percentage, price: 21, contract_duration: 24, tariff_allow: true  }] }

    peak_and_off_peak_plans = { 'PacificLight Energy': [{ peak_start: '7', peak_end: '23', peak_off_start: '23', peak_off_end: '7', peak_price_type: :percentage, peak_price: 16,  peak_off_price_type: :percentage, peak_off_price: 26, tariff_allow: true }],

                            'Keppel Electric': [{ peak_start: '7', peak_end: '23', peak_off_start: '23', peak_off_end: '7', peak_price_type: :unit, peak_price: 20.20, peak_off_price_type: :unit, peak_off_price: 16.16, tariff_allow: true }],

                            'Geneco by Seraya Energy': [{ peak_start: '6', peak_end: '23', peak_off_start: '23', peak_off_end: '6', peak_price_type: :unit, peak_price: 23.01, peak_off_price_type: :unit, peak_off_price: 15.52, tariff_allow: true }],

                            'Sembcorp Power': [{ peak_start: '7', peak_end: '19', peak_off_start: '19', peak_off_end: '7', peak_price_type: :unit, peak_price: 21.40, peak_off_price_type: :unit, peak_off_price: 25.31, tariff_allow: true }] }

    suppliers =  [{ name: 'SP Group', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_01.png').open, website_link: 'https://www.spgroup.com.sg' },
                  { name: 'Best Electricity Supply', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_01.jpg').open, website_link: 'https://bestelectricity.com.sg' },
                  { name: 'Diamond Electric', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_12.jpg').open, website_link: 'https://www.diamond-electric.com.sg' },
                  { name: 'Environmental Solutions (Asia)', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_02.jpg').open, website_link: 'https://espower.com.sg' },
                  { name: 'iSwitch', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_03.jpg').open, website_link: 'https://iswitch.com.sg' },
                  { name: 'Keppel Electric', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_04.jpg').open, website_link: 'https://www.keppelelectric.com' },
                  { name: 'Ohm Energy', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_05.jpg').open, website_link: 'https://www.ohm.sg' },
                  { name: 'PacificLight Energy', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_06.jpg').open, website_link: 'https://pacificlight.com.sg' },
                  { name: 'Sembcorp Power', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_07.jpg').open, website_link: 'https://www.sembcorppower.com' },
                  { name: 'Senoko Energy', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_08.jpg').open, website_link: 'https://www.senokoenergy.com' },
                  { name: 'Geneco by Seraya Energy', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_09.jpg').open, website_link: 'https://www.geneco.sg' },
                  { name: 'Sunseap Energy', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_10.jpg').open, website_link: 'https://www.sunseap.com' },
                  { name: 'Tuas Power Supply', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_13.jpg').open, website_link: 'https://savewithtuas.com' },
                  { name: 'Union Power', logo: Rails.root.join('app/front_end/packs/images/ret_logo_xs_11.jpg').open, website_link: 'https://www.unionpower.com.sg' }]

    ElectricitySupplier.create!(suppliers)

    ElectricitySupplier.all.each do |electricity_supplier|
      plan = plans[electricity_supplier.name.to_sym]
      peak_and_off_peak_plan = peak_and_off_peak_plans[electricity_supplier.name.to_sym]
      plan && electricity_supplier.suppliers_plans.create!(plan)
      peak_and_off_peak_plan && electricity_supplier.peak_and_off_peak_plans.create!(peak_and_off_peak_plan)
    end
  end
end
