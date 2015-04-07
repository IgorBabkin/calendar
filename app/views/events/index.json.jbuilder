json.array!(@events) do |event|
  json.extract! event, :id, :start
  json.title event.name
end
