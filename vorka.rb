#usage ruby -rubygems vorka.rb <category> <length> <number of names>
require 'json'

def extract_letters(_string)
    _string.gsub(/[^A-Za-z]/, '').downcase.split //
end

def chain(companies, vertical)
    chain = {}
    companies[vertical].each do |company|
        letters = extract_letters company
        letters.each{|letter| chain[letter]||=[]}
    begin
        letters[0..-2].zip(letters[1..-1]).each{|key,value| chain[key].push(value)}
    rescue
        puts letters
    end
end
    chain
end

def generate(length, chain)
	items = chain.keys
	result = []
	while !items.empty? and result.length < length 
		item = items.sample
		result.push item
        	items = chain[item]
	end
	result.join.capitalize 
end

Encoding.default_external = Encoding::UTF_8

companies_json = IO.read "company_grouped.json"
companies = JSON.parse(companies_json)

if ARGV.length < 3
 puts "Wrong usage ruby -rubygems vorka.rb <category> <length> <number of name>"
 exit
end


vertical = ARGV[0]
length = ARGV[1].to_i
num_name = ARGV[2].to_i

companies.keys.each do |vertical|
    chain = chain companies, vertical
    puts vertical.upcase
    num_name.times{|i| puts generate(length, chain)}
end
