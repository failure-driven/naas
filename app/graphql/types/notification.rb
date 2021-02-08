module Types
  class Notification < Types::BaseObject
    field :id, ID, null: false
    field :data, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
