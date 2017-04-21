class Operations
  attr_reader :model_class, :clauses

  def initialize model_class, clauses
    @model_class = model_class
    @clauses = clauses
  end

  def parse!
    clauses.map do |clause|
      # clause = clause.to_h
      # clause['value'] = clause['value'].to_i if model_class.columns_hash[clause['field']].type == :integer
      OperatorPlugin.for_operand(clause['operator']).new(clause).parse
    end
  end
end
