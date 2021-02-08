module Resolvers
  class Notifications < Resolvers::BaseResolver
    type [Types::Notification], null: false

    def resolve
      ::Notification
        .order(::Notification.arel_table[:created_at].desc)
        .first(2)
    end
  end
end
