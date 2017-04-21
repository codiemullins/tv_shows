class Operators::Gt < OperatorPlugin
  operator "GT", "SQL greater-than match with >"

  def parse
    ["#{field} > ?", value]
  end
end
