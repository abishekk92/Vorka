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
