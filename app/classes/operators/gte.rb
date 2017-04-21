class Operators::Gte < OperatorPlugin
  operator "GTE", "SQL greater-than or equal match with >="

  def parse
    ["#{field} >= ?", value]
  end
end
