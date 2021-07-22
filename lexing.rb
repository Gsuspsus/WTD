# frozen_string_literal: true

module Lexing
  CONVERTERS = {
    int: ->(x) { x.to_i },
    float: ->(x) { x.to_f },
    bool: ->(x) { x == 'true' },
    string: ->(x) { x.gsub(/"(\w*)"/, '\1') }
  }.freeze

  DEFAULT_CONVERTER = ->(x) { x.to_s }

  # Represents the basic syntactical unit in the language
  class Token
    attr_reader :type, :value

    def initialize(type, value)
      @type = type.to_sym
      @value = if block_given?
                 yield(@type, value)
               else
                 value.to_s
               end
    end
  end

  # Handles converting a string into a list of tokens
  class Lexer
    INVALID_LEXING_ERROR = 'Unlexable element: "%s"'

    def initialize(rules)
      @rules = Array(rules)
      @current_chunk = nil
    end

    def tokenize(str)
      tokens = prepare_string(str).split.map do |chunk|
        @current_chunk = chunk
        unlexable_error_abort if invalid_chunk?
        Token.new(find_matching_rule.type, chunk) do |type, value|
          CONVERTERS.fetch(type, DEFAULT_CONVERTER).call(value)
        end
      end
      TokenStream.new(tokens)
    end

    private

    def prepare_string(str)
      str.downcase.gsub(/([()\[\],=])/, ' \1 ')
    end

    def unlexable_error_abort
      raise ArgumentError, format(INVALID_LEXING_ERROR,@current_chunk)
    end

    def invalid_chunk?
      find_matching_rule.nil?
    end

    def find_matching_rule
      @rules.find { |rule| @current_chunk.match(rule.regex) }
    end
  end
end

# A class for a collection of tokens to be passed to the parser
class TokenStream
  attr_reader :tokens

  def initialize(tokens)
    @tokens = Array(tokens)
    @index = 0
  end

  def current
    @tokens[@index]
  end

  def peek(length)
    @tokens[@index + length]
  end

  def next_token
    @index += 1
  end

  def expect(type)
    if type != current.type
      puts "unexpected token, expected #{type} but got #{current.type}"
      false
    else
      true
    end
  end

  def next_if_expected(type)
    next_token if expect(type)
  end

  def inspect
    pp @tokens and nil
  end
end
