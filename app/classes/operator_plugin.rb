require './lib/plugin'

class OperatorPlugin
  include Plugin

  class_attribute :operand, :description
  attr_reader :operator, :field, :value

  plugin_path "#{Rails.root}/app/classes/operators/*.rb"

  def initialize where
    @operator = where['operator']
    @field = where['field']
    @value = where['value']
  end

  def self.for_operand operand
    plugins.find { |handler| handler.operand == operand }
  end

  def self.operators
    plugins.map(&:operand)
  end

  def self.operator operand, description = nil
    self.operand = operand
    self.description = description || operand
  end

  def parse
    raise NotImplementedError.new("OH NOES, don't know how to parse #{operator}!")
  end
end
