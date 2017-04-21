class Operators::Lt < OperatorPlugin
  operator "LT", "SQL less-than match with <"

  def parse
    ["#{field} < ?", value]
  end
end
