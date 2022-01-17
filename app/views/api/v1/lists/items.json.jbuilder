json.array! @items do |item|
  json.extract! item,
    :name,
    :content
end