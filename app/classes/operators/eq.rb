class Operators::Eq < OperatorPlugin
  operator "EQ", "SQL exact match with equal"

  def parse
    ["#{field} = ?", "#{value}"]
  end
end
