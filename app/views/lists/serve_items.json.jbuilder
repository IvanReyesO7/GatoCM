json.array! @items do |item|
  json.extract! item,
    :id,
    :content
end