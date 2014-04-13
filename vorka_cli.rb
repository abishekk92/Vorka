require_relative 'vorka'

Encoding.default_external = Encoding::UTF_8

companies_json = IO.read "company_grouped.json"
companies = JSON.parse(companies_json)

if ARGV.length < 3
 puts "Wrong usage ruby vorka_cli.rb <category> <length> <number of name>"
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

