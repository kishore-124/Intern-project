json.array! @topics do |category|
  json.id category.id
  json.title category.title
end
