module Timer

  def post_time(message, &block)
    start_time = Time.now

    result = if block.arity > 0
      yield(start_time)
    else
      yield
    end

    elapsed = Time.now - start_time

    Rails.logger.debug "#{message} #{elapsed}"
    result
  end

  def time(message, &block)
    start_time = Time.now

    print message

    result = if block.arity > 0
      yield(start_time)
    else
      yield
    end

    elapsed = Time.now - start_time

    Rails.logger.debug " #{elapsed}"
    result
  end

end
