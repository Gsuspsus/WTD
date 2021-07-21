# frozen_string_literal: true

module Parsing
  ValueExpression = Struct.new(:value)
  FunctionCallExpression = Struct.new(:name, :args)
  IfElseStatement = Struct.new(:cond, :left, :right)
  VarDeclarationStatement = Struct.new(:name, :value)
end
