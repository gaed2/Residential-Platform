namespace :region_cities do
  desc "Add region and cities"
  task add: :environment do

      west = ["Bukit Merah", "Toa Payoh", "Geylang", "Kallang", "Queenstown", "Bishan", "Bukit Timah", "Marine Parade",
              "Jurong West","Choa Chu Kang","Bukit Batok","Bukit Panjang","Clementi", "Jurong East","Western Water Catchment",
              "Pioneer","Tuas","Boon Lay","Tengah","Western Island"]
   central = ["Novena","Outram","Tanglin","Rochor","River Valley","Newton","Downtown Core","Singapore River",
              "Southern Islands", "Orchard","Museum","Marina East","Marina South","Straits View"]
     north = ["Simpang North", "Central Water Catchment", "Woodlands", "Yishun", "Sembawang", "Mandai", "Sungei Kadut", "Lim Chu Kang"]
north_east = ["Hougang", "Sengkang","Ang Mo Kio", "Serangoon", "Punggol", "Seletar", "North-Eastern Islands"]
      east = ["Bedok", "Tampines","Pasir Ris", "Changi", "Paya Lebar", "Changi Bay"]
    regions = {'Central Region' => central, 'East Region' => east, 'North Region' => north,
               'North-East Region' => north_east, 'West Region' => west}

    regions.each do |region, cities|
      region = Region.create(name: region)
      cities.each do |city|
        City.create(name: city, region_id: region.id)
      end
    end
  end
end
