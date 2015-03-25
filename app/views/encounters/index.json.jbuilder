json.array!(@encounters) do |encounter|
  json.extract! encounter, :id, :completed
  json.url encounter_url(encounter, format: :json)
end
