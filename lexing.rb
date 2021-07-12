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
      str.downcase.gsub(/([()\[\],=])/, ' \1 ').split.each do |chunk|
        @current_chunk = chunk
        print_unlexable_error if invalid_chunk?
        matching_rule = find_matching_rule
        tokens << Token.new(matching_rule[1], chunk)
      end
      return TokenStream.new(tokens)
    end

    def print_unlexable_error
      raise ArgumentError, INVALID_LEXING_ERROR % @current_chunk
    end

    def invalid_chunk?
      find_matching_rule == nil
    end

    def find_matching_rule
      @rules.find { |regex, _| @current_chunk.match(regex) }
    end
  end
end

class TokenStream 
	attr_reader :tokens

	def initialize(tokens)
		@@tokens = tokens
		@index = 0
	end

	def current
		@@tokens[@index]
	end

	def peek(n)
		@@tokens[@index+n]
	end

	def next_token
		@index += 1
	end

	def expect(t)
		if t != current.type 
			puts "unexpected token, expected #{t.to_s} but got #{current.type.to_s}" 
			return false
		else
			return true
		end
	end
	def next_if_expected(t)
		next_token if expect(t)
	end

  def inspect
    pp @@tokens and nil
  end
end