def extract_letters(_string)
    _string.gsub(/[^A-Za-z]/, '').downcase.split //
end

def frequency(word)
  Hash[extract_letters(word).group_by(&:chr).map { |k, v| [k, v.size] }]
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

def print_and_exit(message)
    puts message
    exit
end

def chain(companies)
    chain = {}
    companies.each do |company|
        letters = extract_letters company
        unless letters.empty?
            letters[0..-2].zip(letters[1..-1]).each do |key,value|
                chain[key] ||= []
                chain[key].push(value)
            end
    end
end
   chain
end
