require 'json'
json=IO.read "companies.json"
companies=JSON.parse(json)
web=companies.select{ |company| company["category_code"]=="web" }
ecommerce=companies.select{ |company| company["category_code"]=="ecommerce"}
puts web

  



 

