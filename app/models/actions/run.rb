class Actions::Run < Action
  class << self
    def generate!(params, path)
      character = params[:character] ?
        params[:character] :
        Character.find(params[:character_id])

      unless params[:finished_at]
        params[:finished_at] = params[:started_at] + path.length - 1
      end

      self.create!(params)
    end
  end

  def tick(time)
    super(time)
  end
end

