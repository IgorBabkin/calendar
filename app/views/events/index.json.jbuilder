json.array!(@events) do |event|
  json.extract! event, :id, :title, :since, :periodicity
  json.start event.date
end
