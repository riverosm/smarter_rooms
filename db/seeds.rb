# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create({name: 'Admin user', email: 'room_reservation@ar.ibm.com', phone: '5286-1111',
  password: 'CodeAcademy$1', password_confirmation: 'CodeAcademy$1', admin: true})