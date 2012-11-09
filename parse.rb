require 'json'
json=IO.read "companies.json"
companies=JSON.parse(json)
companies_group=companies.group_by do |company|
	case company["category_code"]
	when /web/
		"web"
	when /mobile/
		"mobile"
	when /ecommerce/
		"ecommerce"
	when /education/
		"education"
	when /software/
		"software"
	when /hardware/
		"hardware"
	when /enterprise/
		"enterprise"
	end
end 
File.open("company_grouped.json",'w'){|f| f.write(companies_group.to_json)}

  



 

