# frozen_string_literal: true

require_relative 'lexing'

lexer = Lexing::Lexer.new({ /[a-z]+/ => :ident, /\d+/ => :number })
p lexer.tokenize(gets.chomp)
