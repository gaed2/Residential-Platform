namespace :property_categories_and_sub_categories do
  desc "Update categories and sub categories"
  task update: :environment do
    property_sub_categories = { 'Residential': [{ name: '1-Room' }, { name: '2-Room' }, { name: '3-Room' },
                                                { name: '4-Room' }, { name: '5-Room' }, { name: 'Executive' },
                                                { name: 'Maisonette' }, { name: 'Condo' }, { name: 'Terrace' },
                                                { name: 'Semi-Detached' }, { name: 'Detached (Bungalow)' },
                                                { name: 'Good-class Bungalow' }] }

    property_sub_categories.keys.each do |category_name|
      PropertyCategory.create!(name: category_name)
    end

    PropertyCategory.all.each do |property_category|
      sub_categories = property_sub_categories[property_category.name.to_sym]
      sub_categories && property_category.property_sub_categories.create!(sub_categories)
    end
  end
end
