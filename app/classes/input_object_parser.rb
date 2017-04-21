class InputObjectParser
  attr_reader :input_object

  def initialize input_object
    @input_object = input_object
  end

  def parse
    input_object.map do |where|
      ap where.to_h
      case where['operator']
      when "LIKE"
        foo = ["#{where['field']} LIKE ?", "%#{where['value']}%"]
        ap foo
        foo
      else
        raise "Invalid operator"
      end
    end
  end
end
