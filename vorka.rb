#usage ruby -rubygems vorka.rb <category> <length> <number of names>
require 'json'

def extract_letters(_string)
    _string.gsub(/[^A-Za-z]/, '').downcase.split //
end

def frequency(word)
  Hash[extract_letters(word).group_by(&:chr).map { |k, v| [k, v.size] }]
end

def chain(companies, vertical)
    chain = {}
    local_model = {}
    companies[vertical].each do |company|
        letters = extract_letters company
        letters.each do |letter|
            chain[letter]||= []
            local_model[letter]||= {}
        end
    begin
        letters[0..-2].zip(letters[1..-1]).each do |key,value|
            chain[key].push(value)
            local_model[key][value]||=0
            local_model[key][value]+=1
        end
    rescue
        puts letters
    end
end
    return chain, local_model
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

def probability_model(frequencies)
    total = frequencies.values.reduce(:+)
    Hash[frequencies.map {|letter, count| [letter, count.to_f/total]}]
end

def quartiles_2_3(probabilities)
    values = probabilities.values.sort
    opt_group_size = values.size/3
    (values[opt_group_size*2]...values[opt_group_size*3])
end

def score(word, probabilities, quartile_vals)
    in_range = extract_letters(word).select{ |letter| quartile_vals.include? probabilities[letter] }.size
    in_range.to_f/word.size
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

chain, local_model = chain companies, vertical
frequencies = frequency companies[vertical].join ""
probabilities = probability_model frequencies
quartile_vals = quartiles_2_3 probabilities

so_far = 0

until so_far == num_name
    word = generate(length, chain)
    score_val = score word, probabilities, quartile_vals
    if score_val > 0.5
        puts word
        so_far += 1
    end
end
