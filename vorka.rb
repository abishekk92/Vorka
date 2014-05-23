require 'json'
require_relative 'utils'

class NameGenerator
    
    def initialize(companies, length)
        @chain = chain companies
        @length = length
        @validator = FitnessValidator.new companies
    end
    
    def generate(num_name, so_far=0)
        unless so_far == num_name
            word = generate_word

            score = @validator.fitness word
            if score.is_fit?
                puts word
                generate(num_name, so_far+1)
            else
                generate(num_name, so_far)
            end
        end
    end  
    
    def generate_word(items=@chain.keys, result=[])
        if !items.empty? and result.length < @length
            item = items.sample
            generate_word(@chain[item], result.push(item))
        else
            result.join.capitalize
        end
    end
end

class FitnessValidator
    
    def initialize(companies)
        @probabilities = probability_model frequency companies.join ""
        @quartiles_2_3 = quartiles_2_3 @probabilities
    end    
    def fitness(word)
        in_range = extract_letters(word).select{ |letter| @quartiles_2_3.include? @probabilities[letter] }.size
        FitnessScore.new in_range.to_f/word.size
    end

end
class FitnessScore
    def initialize(score)
        @score = score
    end
    
    def is_fit?
        @score > 0.5
    end

end
