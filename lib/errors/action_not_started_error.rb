module Errors
  class ActionNotStartedError < StandardError
    def message
      "Must start the action before interacting!"
    end
  end
end

