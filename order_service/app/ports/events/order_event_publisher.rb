module Events
  class OrderEventPublisher
    def publish_created(order)
      raise NotImplementedError
    end
  end
end
