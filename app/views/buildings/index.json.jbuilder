json.array!(@buildings) do |building|
  json.extract! building, :id, :name, :location_id
  json.url building_url(building, format: :json)
end
