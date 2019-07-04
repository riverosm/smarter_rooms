# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create({name: 'Admin user', email: 'room_reservation@ar.ibm.com', phone: '5286-1111',
  password: 'CodeAcademy$1', password_confirmation: 'CodeAcademy$1', admin: true})

Building.find_or_create_by({name: "Martinez Módulo A", address: "Hipólito Yrigoyen 2149", 
  latitude: -34.5007196, longitude: -58.5282738})
Building.find_or_create_by({name: "Martinez Módulo B", address: "Hipólito Yrigoyen 2149", 
  latitude: -34.5007196, longitude: -58.5282738})
Building.find_or_create_by({name: "Catalinas", address: "Ing. Butty 275", latitude: -34.5961506 , longitude: -58.3733886})