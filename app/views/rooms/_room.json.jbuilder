json.extract! room, :id, :name, :code, :floor, :max_capacity, :active, :building_id, :created_at, :updated_at
json.url room_url(room, format: :json)
