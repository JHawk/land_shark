require 'namey'

class Characters::Human < Character

  class << self
    def generator
      @@generator ||= Namey::Generator.new
    end

    def available_genders
      %w(male female none)
    end

    def rand_identity
      gender = self.available_genders.sample

      name = if gender != 'none'
        generator.generate(type: gender.to_sym, with_surname: true, frequency: :all)
      else
        generator.generate(frequency: :all, with_surname: true).split(' ').last
      end

      {
        name: name,
        gender: gender
      }
    end
  end
end

