#usage ruby -rubygems vorka.rb <category> <length> <number of names>
require 'json'
require_relative 'utils'

module Vorka
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


    class NameGenerator
        
        attr_accessor :chain

        def generate(length)
            items = self.chain.keys
            result = []
            while !items.empty? and result.length < length
                item = items.sample
                result.push item
                items = self.chain[item]
            end
            result.join.capitalize
        end
    end

    class FitnessValidator
        attr_accessor :probabilities, :quartiles_2_3
        
        def fitness(word)
            in_range = extract_letters(word).select{ |letter| self.quartiles_2_3.include? self.probabilities[letter] }.size
            in_range.to_f/word.size
        end

        def self.is_fit?(fitness_score)
            fitness_score > 0.5
        end

    end
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

include Vorka
name_generator = Vorka::NameGenerator.new()
name_generator.chain, _ = Vorka::chain companies, vertical

validator = Vorka::FitnessValidator.new()
validator.probabilities = probability_model frequency companies[vertical].join ""
validator.quartiles_2_3 = quartiles_2_3 validator.probabilities

so_far = 0

until so_far == num_name
    word = name_generator.generate(length)

    score = validator.fitness word
    if Vorka::FitnessValidator.is_fit? score
        puts word
        so_far += 1
    end
end
