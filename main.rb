# frozen_string_literal: true

require_relative 'lexing'
require_relative 'lexer_rules_loader'

lexer = Lexing::Lexer.new(LexerRulesLoader.load('default_lexing_rules.json'))
p lexer.tokenize(gets.chomp)