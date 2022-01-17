json.array! @lists do |list|
    json.extract! list,
      :name,
      :name_format
      json.items list.items do |item|
        json.extract! item, :name, :content
      end
  end