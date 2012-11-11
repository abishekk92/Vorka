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
def sanitize_name(name)
	name=name.split " "
	name=name.first.gsub(%r(\..*),"")
	return name
end 
%w[web ecommerce software education mobile enterprise hardware].each do |category|
  companies_group[category].map!{|company| sanitize_name(company["name"])}
end 
File.open("company_grouped.json",'w'){|f| f.write(companies_group.to_json)}


  



 

