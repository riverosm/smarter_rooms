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

Accesorie.find_or_create_by({name: "Proyector"})
Accesorie.find_or_create_by({name: "Pizarra"})
Accesorie.find_or_create_by({name: "Videoconferencia"})

martinez_ma = Building.find_by(name: "Martinez Módulo A")

Room.find_or_create_by({name: "Amanecer", floor: 1, code: "A101", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Bermejo", floor: 1, code: "A102", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Buenos Aires", floor: 1, code: "A103", max_capacity: 8, building: martinez_ma})
Room.find_or_create_by({name: "Embarcadero", floor: 1, code: "A104", max_capacity: 12, building: martinez_ma})
Room.find_or_create_by({name: "Envisioning 1", floor: 1, code: "A105", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Envisioning 2", floor: 1, code: "A106", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Humboldt", floor: 1, code: "A107", max_capacity: 8, building: martinez_ma})
Room.find_or_create_by({name: "Plaza de Mayo", floor: 1, code: "A108", max_capacity: 8, building: martinez_ma})
Room.find_or_create_by({name: "Pumahuasi", floor: 1, code: "A109", max_capacity: 12, building: martinez_ma})
Room.find_or_create_by({name: "Reflejos", floor: 1, code: "A110", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Republica", floor: 1, code: "A111", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Maymara", floor: 1, code: "A112", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Yacht Club", floor: 1, code: "A113", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Educación", floor: 1, code: "A114", max_capacity: 40, building: martinez_ma})
Room.find_or_create_by({name: "Riachuelo", floor: 2, code: "A201", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Tarija", floor: 2, code: "A202", max_capacity: 8, building: martinez_ma})
Room.find_or_create_by({name: "Darsena Norte", floor: 2, code: "A203", max_capacity: 12, building: martinez_ma})
Room.find_or_create_by({name: "Puerto Madero", floor: 2, code: "A204", max_capacity: 12, building: martinez_ma})
Room.find_or_create_by({name: "Picasso", floor: 2, code: "A205", max_capacity: 10, building: martinez_ma})
Room.find_or_create_by({name: "Van Gogh", floor: 2, code: "A206", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Belgrano", floor: 2, code: "A207", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Av Corrientes", floor: 2, code: "A208", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Incahuasi", floor: 2, code: "A209", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "El Faro", floor: 2, code: "A210", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "Monet", floor: 2, code: "A211", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Pilcomayo", floor: 2, code: "A212", max_capacity: 8, building: martinez_ma})
Room.find_or_create_by({name: "Retiro", floor: 2, code: "A213", max_capacity: 10, building: martinez_ma})
Room.find_or_create_by({name: "Puente de la Mujer", floor: 2, code: "A214", max_capacity: 12, building: martinez_ma})
Room.find_or_create_by({name: "Catalinas", floor: 2, code: "A215", max_capacity: 4, building: martinez_ma})
Room.find_or_create_by({name: "La Boca", floor: 2, code: "A216", max_capacity: 6, building: martinez_ma})
Room.find_or_create_by({name: "Tilcara", floor: 2, code: "A217", max_capacity: 8, building: martinez_ma})