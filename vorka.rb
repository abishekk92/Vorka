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

