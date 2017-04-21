class Operators::Lte < OperatorPlugin
  operator "LTE", "SQL less-than or equal match with <="

  def parse
    ["#{field} <= ?", value]
  end
end
