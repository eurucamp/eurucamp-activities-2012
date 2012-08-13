# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

raise "You are bad boy" if Rails.env.production?

p User.create! :name => 'Admin', :email => 'info+activities@eurucamp.org', :password => 'dontruninproduction', :password_confirmation => 'dontruninproduction'

