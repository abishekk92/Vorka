require 'json'
companies_json=IO.read "company_grouped.json"
companies=JSON.parse(companies_json)
vertical=ARGV[0]
chain={}
seperator=' '
companies[vertical].each do |company|
	name=company["name"].downcase.split(//)
	name_pair=name.zip(name.drop(1))
	name_pair.delete_at(-1)
	name_pair.each{|key,value| chain[key]||=[]<<value}
	chain[name[-1]]||=[]<<seperator
	chain[seperator]||=[]<<name.first
end 
def generate(seperator,chain)
	name=[]
	curr=seperator
	until curr==seperator and name
		curr=chain[curr].choice #sample in 1.9.3
		name<<curr
		return name.join
	end
end
new_name=''
until new_name.length>5 or new_name.length<10
	new_name+=generate(seperator,chain)
end 
puts new_name



