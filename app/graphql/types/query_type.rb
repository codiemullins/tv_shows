MODEL_TO_TYPE = {}

DateType = GraphQL::ScalarType.define do
  name "Date"
  description "Date since epoch in seconds"

  coerce_input -> (value) { Date.parse(value) }
  coerce_result -> (value) { value.is_a?(Time) ? value.to_date.to_s : value.to_s }
end

def convert_type type
  case type
  when :string, :text
    types.String
  when :integer
    types.Int
  when :date, :datetime
    DateType
  else
    raise "Unable to interpet type #{type}, for GraphQL"
  end
end

def create_type model_class
  GraphQL::ObjectType.define do
    name model_class.name
    description "Generated programmatically from model: #{model_class.name}"

    implements GraphQL::Relay::Node.interface
    global_id_field :id

    # Make a field for each column:
    model_class.columns.each do |column|
      next if column.name == "id"
      field(column.name, convert_type(column.type))
    end

    model_class.reflect_on_all_associations.each do |association|
      field association.name, -> { MODEL_TO_TYPE[association.klass] } do
        resolve ->(obj, args, ctx) {
          RecordLoader.for(association.klass).load obj.send(association.foreign_key)
        }
      end
    end
  end
end

[Show, Network, Country].each { |model_class| MODEL_TO_TYPE[model_class] = create_type(model_class) }

Operator = GraphQL::EnumType.define do
  name "Operators"
  description "SQL Operators for compiling query variables"
  OperatorPlugin.plugins.each do |plugin|
    value plugin.operand, plugin.description
  end
end

WhereInput = GraphQL::InputObjectType.define do
  name "Where"
  argument :field, types.String
  argument :value, types.String
  argument :operator, Operator
end

ViewerType = GraphQL::ObjectType.define do
  name "User"

  implements GraphQL::Relay::Node.interface
  global_id_field :id

  field :show do
    type MODEL_TO_TYPE[Show]
    argument :id, !types.ID
    description "Find a Show by ID"
    resolve -> (_, args, _) { RecordLoader.for(Show).load(args["id"]) }
  end

  connection :shows, MODEL_TO_TYPE[Show].connection_type do
    argument :where, types[WhereInput], "Sample InputObjectType testing"

    resolve -> (_, args, _) do
      resolver_scope = Show.unscoped
      resolver_scope = resolver_scope.where(*Operations.new(Show, args[:where]).parse!) if args[:where]
      resolver_scope
    end
  end

end

Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  # Used by Relay to lookup objects by UUID:
  field :node, GraphQL::Relay::Node.field
  # # Fetches a list of objects given a list of IDs
  field :nodes, GraphQL::Relay::Node.plural_field


  field :viewer, ViewerType do
    resolve -> (obj, args, ctx) {
      true
    }
  end
end
