# \<Code Academy\> Nivel 3 - Trabajo final

## Running and configurations

```sh
$ git clone "git@github.ibm.com:riverosm/smarter_rooms.git"
$ cd smarter_rooms
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
$ cat config/initializers/config_smarter_rooms.rb
SmarterRooms::Application.config.smarter_rooms_rooms_api_url = 'https://ca-3-api.mybluemix.net/' # IoT API URL
SmarterRooms::Application.config.smarter_rooms_rooms_api_path = 'api/v1/rooms/' # IoT rooms API path
SmarterRooms::Application.config.smarter_rooms_rooms_per_page = 6 # Rooms per page for pagination
SmarterRooms::Application.config.smarter_rooms_calendar_start_time = '09:00' # Calendar start time
SmarterRooms::Application.config.smarter_rooms_calendar_end_time = '18:00' # Calendar end time
SmarterRooms::Application.config.smarter_rooms_calendar_slot_duration = '00:15' # Calendar slot duration
SmarterRooms::Application.config.smarter_rooms_calendar_hidden_days = '[0, 6]' # Calendar hide weekend
$ rails s
```

Ruby on Rails asignará el puerto configurado y se podrá acceder desde el navegador, por ejemplo:

http://127.0.0.1:3000/

Se generará un usuario administrador:

<b>room_reservation@ar.ibm.com</b>

<b>CodeAcademy$1</b>

## Navegación

## Contacto

![Imagen autor](https://github.ibm.com/riverosm/smarter_rooms/blob/master/public/riverosm.jpg)

* Matias Riveros
* IBM Argentina
* riverosm@ar.ibm.com
