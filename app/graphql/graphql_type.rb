class GraphqlType
  def initialize model_class
    @model_class = model_class
  end

  def create!
    GraphQL::ObjectType.define do
      name @model_class.name
      description "Generated programmatically from model: #{@model_class.name}"

      implements GraphQL::Relay::Node.interface
      global_id_field :id

      # Make a field for each column:
      @model_class.columns.each do |column|
        next if column.name == "id"
        field(column.name, convert_type(column.type))
      end

      @model_class.reflect_on_all_associations.each do |association|
        field(association.name, -> { MODEL_TO_TYPE[association.klass] })
      end
    end
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
end
