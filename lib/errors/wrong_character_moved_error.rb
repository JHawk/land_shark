module Errors
  class WrongCharacterMovedError < StandardError
    def initialize(location, character)
      @location = location
      @character = character
    end

    def message
      s = "It is not #{@character.name}'s turn!"
      if @location.current_character
        s << " It's #{@location.current_character.try(:name)}'s!"
      end
      s
    end
  end
end

