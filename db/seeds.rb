# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rake::Task['supplier_and_their_plans:create'].invoke

Rake::Task['property_categories_and_sub_categories:update'].invoke

Rake::Task['energy_saving_checklist:update'].invoke

# Add region and cities
Rake::Task['region_cities:add'].invoke

if AdminUser.count == 0
  AdminUser.create!(
    email: Figaro.env.ADMIN_EMAIL, password: Figaro.env.ADMIN_PASSWORD, password_confirmation: Figaro.env.ADMIN_PASSWORD
  )
end