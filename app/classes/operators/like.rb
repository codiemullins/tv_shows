class Operators::Like < OperatorPlugin
  operator "LIKE", "SQL Fuzzy match using LIKE operand"

  def parse
    ["#{field} LIKE ?", "%#{value}%"]
  end
end
