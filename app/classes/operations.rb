class Operations
  attr_reader :clauses

  def initialize clauses
    @clauses = clauses
  end

  def parse!
    clauses.map { |clause| OperatorPlugin.for_operand(clause['operator']).new(clause).parse }
  end
end
