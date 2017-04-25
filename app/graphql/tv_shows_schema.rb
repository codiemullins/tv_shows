require 'graphql/batch'
require 'promise'

TvShowsSchema = GraphQL::Schema.define do
  query Types::QueryType

  lazy_resolve Promise, :sync
  instrument :query, GraphQL::Batch::Setup

  id_from_object ->(object, type_definition, query_ctx) {
    id = object.respond_to?(:id) ? object.id : 42
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, id)
  }

  object_from_id ->(id, query_ctx) {
    type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
    RecordLoader.for(type_name.constantize).load item_id
  }

  resolve_type ->(obj, ctx) { MODEL_TO_TYPE[obj.class] }
end
