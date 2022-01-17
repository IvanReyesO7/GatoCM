json.array! @lists do |list|
  json.extract! list,
    :name,
    :name_format
end