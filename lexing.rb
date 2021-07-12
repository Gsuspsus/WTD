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
    INVALID_LEXING_ERROR = 'Unlexable element: "%s"'

    def initialize(rules)
      @rules = rules
      @current_chunk = nil
    end

    def tokenize(str)
      tokens = []
      str.downcase.split.each do |chunk|
        @current_chunk = chunk
        print_unlexable_error if invalid_chunk?
        matching_rule = find_matching_rule
        tokens << Token.new(matching_rule[1], chunk)
      end
      tokens
    end

    def print_unlexable_error
      raise ArgumentError, INVALID_LEXING_ERROR % @current_chunk
    end

    def invalid_chunk?
      @rules.none? { |r| @current_chunk.match(r[0]) }
    end

    def find_matching_rule
      @rules.find { |regex, _| @current_chunk.match(regex) }
    end
  end
end
