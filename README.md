# \<Code Academy\> Nivel 3 - Trabajo final

Repository clonated from IBM Github

## Installation

```sh
$ git clone "git@github.ibm.com:riverosm/smarter_rooms.git"
$ cd smarter_rooms
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
```

## Configuration

Some settings could be changed before running the app:

```sh
$ cat config/initializers/config_smarter_rooms.rb
SmarterRooms::Application.config.smarter_rooms_rooms_api_url = 'https://ca-3-api.mybluemix.net/' # IoT API URL
SmarterRooms::Application.config.smarter_rooms_rooms_api_path = 'api/v1/rooms/' # IoT rooms API path
SmarterRooms::Application.config.smarter_rooms_rooms_per_page = 6 # Rooms per page for pagination
SmarterRooms::Application.config.smarter_rooms_users_per_page = 5 # Users per page for pagination
SmarterRooms::Application.config.smarter_rooms_calendar_start_time = 9 # Calendar start time
SmarterRooms::Application.config.smarter_rooms_calendar_end_time = 18 # Calendar end time
SmarterRooms::Application.config.smarter_rooms_calendar_slot_duration = '00:15' # Calendar slot duration
SmarterRooms::Application.config.smarter_rooms_calendar_hidden_days = '[0, 6]' # Calendar hide weekend
SmarterRooms::Application.config.smarter_rooms_calendar_max_results = 100 # Max results to show on bookings index
```

## Running

```sh
$ rails s
```

Ruby on Rails will bind the site, for example:

http://127.0.0.1:3000/

An admin user is created with the installation:

User: <b>smarterrooms@ar.ibm.com</b>

Pass: <b>CodeAcademyL$3</b>

## Considerations

* Please consider adding a font awesome icon when creating accesories. For example:
```sh
Accesory.find_or_create_by({name: "Proyector", icon: "video"})
Accesory.find_or_create_by({name: "Pizarra", icon: "chalkboard"})
Accesory.find_or_create_by({name: "Videoconferencia", icon: "file-video"})
Accesory.find_or_create_by({name: "IP Phone", icon: "phone"})
```
A default icon will be displayed if none is configured.
* The date format used is "DD/MM/YYYY"
* If a site name containing "Martinez" is added it will show its location
* If a site name containing "Catalinas" is added it will show its location
* If another site name is added, it will show a IBM logo

## Class diagram

![Class diagram](https://github.com/riverosm/smarter_rooms/blob/master/SmarterRooms.png)

## ToDo

* Refactor Accesory -> Resource or Device
* Refactor Building -> Site
* Refactor Booking -> Reservation
* Rooms map location
* Configuration on database to allow the administrator to change it dynamically

## About

SmarterRooms v1.0 tested on:
- Mozilla Firefox 60.7.2esr for Red Hat Enterprise Linux
- Google Chrome 75.0.3770.100

Developed by:

![Author image](https://github.com/riverosm/smarter_rooms/blob/master/public/riverosm.jpg)

* Matias Riveros
* IBM Argentina
* riverosm@ar.ibm.com
