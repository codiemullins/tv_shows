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
    name(model_class.name)
    description("Generated programmatically from model: #{model_class.name}")
    # Make a field for each column:
    model_class.columns.each do |column|
      if column.name == "id"
        field("id", types.ID)
      else
        field(column.name, convert_type(column.type))
      end
    end

    model_class.reflect_on_all_associations.each do |association|
      field(association.name, -> { MODEL_TO_TYPE[association.klass] })
    end
  end
end

[Show, Network, Country].each { |model_class| MODEL_TO_TYPE[model_class] = create_type(model_class) }

Operator = GraphQL::EnumType.define do
  name "Operators"
  description "SQL Operators for compiling query variables"
  value "LIKE", "Like"
  value "NEQ", "Not Equal"
  value "EQ", "Equal"
  value "GT", "Greater than"
  value "LT", "Less than"
  value "GTE", "Greater than or equal"
  value "LTE", "Less than or equal"
end

WhereInput = GraphQL::InputObjectType.define do
  name("Where")
  argument :field, types.String
  argument :value, types.String
  argument :operator, Operator
end

Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :show do
    type MODEL_TO_TYPE[Show]
    argument :id, !types.ID
    description "Find a Show by ID"
    resolve -> (_, args, _) { Show.find(args["id"]) }
  end

  field :shows do
    type !types[MODEL_TO_TYPE[Show]]
    argument :ids, types[types.ID], "The IDs of the shows"
    argument :where, types[WhereInput], "Sample InputObjectType testing"

    resolve -> (_, args, _) do
      if args[:where]
        clause = InputObjectParser.new(args[:where]).parse
        resolver_scope = Show.unscoped
        clause.each do |where|
          resolver_scope = resolver_scope.where(*where)
        end
        resolver_scope
      elsif args[:ids]
        Show.where(id: args[:ids])
      else
        Show.all
      end
    end
  end
end
