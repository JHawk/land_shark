json.array!(@occupations) do |occupation|
  json.extract! occupation, :id, :name
  json.url occupation_url(occupation, format: :json)
end
