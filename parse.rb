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
    else
        "other"
	end
end

def sanitize_name(name)
	name=name.split " "
	name.first.gsub(%r(\..*),"")
end 

%w[web ecommerce software education mobile enterprise hardware other].each do |category|
  companies_group[category] = companies_group[category].map do |company|
      sanitize_name(company["name"])
    end
end

File.open("company_grouped.json",'w'){|f| f.write(companies_group.to_json)}
