json.extract! @location, :id, :created_at, :updated_at

json.characters @location.characters, :id
