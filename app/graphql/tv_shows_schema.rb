TvShowsSchema = GraphQL::Schema.define do
  query Types::QueryType

  id_from_object ->(object, type_definition, query_ctx) {
    id = object.respond_to?(:id) ? object.id : 42
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, id)
  }

  object_from_id ->(id, query_ctx) {
    type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
    type_name.constantize.find(item_id)
  }

  resolve_type ->(obj, ctx) { MODEL_TO_TYPE[obj.class] }
end
