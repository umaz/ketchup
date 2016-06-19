# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require "csv"

CSV.foreach('db/data1.csv') do |row|
  row.map! do |r|
		if r != nil
			r = r
		else
			r = ""
		end
	end
  Project.create(:name => row[0], :kana => row[1], :about => row[2], :detail => row[3], :synonym => row[4], :kind1 => row[5], :kind2 => row[6], :count => row[7])
end
