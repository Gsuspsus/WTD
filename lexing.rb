# frozen_string_literal: true

module Lexing
  # Represents the basic syntactical unit in the language
  class Token
    attr_reader :type, :value

    def initialize(type, value)
      @type = type
      @value = value
    end
  end

  # Handles converting a string into a list of tokens
  class Lexer
    def initialize(rules)
      @rules = rules
    end

    def tokenize(str)
      tokens = []
      str.downcase.split.each do |chunk|
        puts '' if @rules.none? { |r| chunk.match(r[0]) }
        matching_rule = @rules.find { |regex, _| chunk.match(regex) }
        tokens << Token.new(matching_rule[1].to_sym, chunk)
      end
      tokens
    end
  end
end
